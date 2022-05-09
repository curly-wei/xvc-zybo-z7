/**
 * @file xvc_server.c 
 * @brief Implemention of xvc_server
 * @author dewei
 * @date 2021-2-2  
 * @version 0.0.1 
*/

#include "xvc_server_param.h"
#include "xvc_server.h"

#include <stdio.h>       
#include <stdlib.h>
#include <string.h> //print strings for error.h and invoke strlen, mem*
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <sys/mman.h>
#include <sys/select.h>



/* Don't delete here or others DEBUG_MSG() 
  * Because here can be optimize by gcc
  * when you compile with release mode 
  * see https://godbolt.org/z/f6jPPG
*/
#ifndef RELEASE
  #include <errno.h>
  extern int errno ;
  #define ERROR_MSG(msg_str) _ERROR_MSG_DETAIL(msg_str)
  #define DEBUG_MSG(msg_str) _DEBUG_MSG_GENERIC(msg_str)
#else
  #define ERROR_MSG(msg_str) _ERROR_MSG_SIMPLE(msg_str)
  #define DEBUG_MSG(msg_str)
#endif 

/**
 * @brief C11-Generic implement type generic for select type to DEBUG_MSG
 */
#define _DEBUG_MSG_GENERIC(arg) printf( _DEBUG_MSG_FMTSPEC(arg), arg)
#define _DEBUG_MSG_FMTSPEC(arg) \
  _Generic( (arg), \
              int: "%d\n", \
              default: "%s\n" \
          )

/**
 * @brief Simply stdout of error message
 */
#define _ERROR_MSG_SIMPLE(msg_str) \
  do { \
    perror(msg_str); \
  } while(0)

/**
 * @brief 
 * More detailing error messages, which
 * contained file-name and #-of-line and errno-strings
 */
#define _ERROR_MSG_DETAIL(msg_str) \
  do { \
    fprintf(stderr, "%s: %s\n, at #%d, file: %s\n", \
            (msg_str), strerror(errno), __LINE__, __FILE__); \
  } while(0)


/**
 * @brief Read-in command from fd to buffer 
 * 
 * @param fd File descriptor(fd)
 * @param target Buffer for command content
 * @param target_len length of target to read (Byte)
 * @return true if result is successed, false if any error in the result
 */
static inline bool StreamRead(const fd_t fd, buf_t* target, size_t target_len) {
  buf_t* temp = target;
  while (target_len) {
		ssize_t n_byte_read = read(fd, temp, target_len); // ssize_t != int
		if (n_byte_read <= (ssize_t) 0) // ssize_t [-1 .. +INT_MAX] on linux
			goto fail;
		temp += n_byte_read; //C11, 6.5.6/P8 and 6.2.5/P17
		target_len -= n_byte_read;
	}
	return true;

fail:
  return false;
}

/**
 * @brief Forwaed ehternet data to jtag (or inversed direction)
 * @param eth_fd File Descriptor of Ehernet (socket)
 * @param jtag Memory Map of Jtag Location
 * @return true if result is successed, false if any error in the result
 */
static inline bool JtagEthBridge(const fd_t eth_fd, volatile jtag_t* jtag) {
  enum JtagBridgeState state = kJtagBridgeStart;
  while (true) {
    buf_t cmd[kCmdSize];
    buf_t buffer[kBufferSize], result[kBufferSize/2];
    memset(cmd, 0, kCmdSize);

    if (!StreamRead(eth_fd, cmd, 2) )
      goto out;

    /* Read/judge and reply command */
    if (memcmp(cmd, "ge", 2) == (int) 0 ) {
      state = kWriteXVCInfo;
      if (!StreamRead(eth_fd, cmd, 6) ) 
        goto out;
      memcpy(result, kXVCInfo, strlen(kXVCInfo) );
      if ( write(eth_fd, result, strlen(kXVCInfo)) != strlen(kXVCInfo) ) 
        goto err;
      DEBUG_MSG("Received command getXVCInfo, Replied with:");
      DEBUG_MSG(kXVCInfo);
      break;
    } else if (memcmp(cmd, "se", 2) == (int) 0) {
      state = kSetSCK;
      if (!StreamRead(eth_fd, cmd, 9) ) 
        goto out;
      memcpy(result, cmd+5, 4);
      if (write(eth_fd, result, 4) != (int) 4) 
        goto err;
      DEBUG_MSG("Received command: setTCK, Replied with");
      DEBUG_MSG(cmd+5);
      break;
    } else if (memcmp(cmd, "sh", 2) == (int) 0) {
      if (!StreamRead(eth_fd, cmd, 4) ) 
        goto out; /**??????*/
    } else {
      state = kRecvCmd;
      goto err;
    }

    state = kReadLength;
    int len;
    if (!StreamRead(eth_fd, &len, 4) ) 
      goto err;
    
    state = kChkBuf;
    const int kNByteRd = (len + 7) /8;
    const int kPkgSizeRd = kNByteRd *2;
    if (kPkgSizeRd > kBufferSize )
      goto err;
    
    state = kReadData;
    if (!StreamRead(eth_fd, buffer, kPkgSizeRd) )
      goto err;

    DEBUG_MSG("n Byte be read:");
    DEBUG_MSG(kNByteRd);
    DEBUG_MSG("Data Size:");
    DEBUG_MSG(kPkgSizeRd);
    memset(result, 0, kNByteRd);

    int byte_left = kNByteRd;
    int bit_left = len;
    size_t byte_index = 0;
    int tdi, tdo, tms;

    while (byte_left > 0) {
      tdi = 0;
      tdo = 0;
      tms = 0;

      if (byte_left < 4) {
        memcpy(&tms, &buffer[byte_index], byte_left);
        memcpy(&tdi, &buffer[byte_index + kNByteRd], byte_left);
        
        jtag->length_offset = bit_left;
        jtag->tms_offset = tms;
        jtag->tdi_offset = tdi;
        jtag->ctrl_offset = 0x01;

        tdo = jtag->tdo_offset;
        memcpy(&result[byte_index], &tdo, byte_left);

        break;

      } else {
        memcpy(&tms, &buffer[byte_index], 4);
        memcpy(&tdi, &buffer[byte_index + kNByteRd], 4);
        
        jtag->length_offset = 32;
        jtag->tms_offset = tms;
        jtag->tdi_offset = tdi;
        jtag->ctrl_offset = 0x01;

        tdo = jtag->tdo_offset;
        memcpy(&result[byte_index], &tdo, 4);

        byte_left -= 4;
        bit_left -=32;
        byte_index += 4;
      }
    
    }
    state = kWriteData;
    if (write(eth_fd, result, kNByteRd) != (ssize_t) kNByteRd) 
      goto err;
    
    goto out;
  }

err:
  switch(state) {
    case kWriteXVCInfo: 
      ERROR_MSG("Failed to write XVCInfo"); 
      break;
    case kSetSCK: 
      ERROR_MSG("Failed to write setSCK"); 
      break;
    case kRecvCmd: 
      ERROR_MSG("Received invaild cmd"); 
      break;
    case kReadLength: 
      ERROR_MSG("Read length error"); 
      break;
    case kChkBuf: 
      ERROR_MSG("Buffer size exceeded"); 
      break;
    case kReadData: 
      ERROR_MSG("Read data error"); 
      break;
    case kWriteData: 
      ERROR_MSG("Write data error"); 
      break;
    default:
      ERROR_MSG("Unknow error when JtagEthBridge");
      break;
  }
  return false;

out:
  return true;
};

int main() {
  enum PreactionState pre_state = kProgStart;
  DEBUG_MSG("Starting XVC Server");
  
  /* init fd to uio */
  pre_state = kInitUIOFD;
  DEBUG_MSG("Opening UIO...");
  const fd_t xvc_fd_uio = open(kUIOPath, O_RDWR);
  if (xvc_fd_uio == kUnixFailed) 
    goto pre_err;
  
  /* Mapping jtag memory from somewhere of memory to uio_port */
  DEBUG_MSG("mmaping...");
  pre_state = kInitJtagMMap;
  volatile jtag_t* xvc_memobj = (volatile jtag_t*) mmap(
      NULL, kMapSize, PROT_READ | PROT_WRITE, 
      MAP_SHARED, xvc_fd_uio, 0);
  if (xvc_memobj == MAP_FAILED) 
    goto pre_err;
  
  /* init fd to socket, use TCP mode */
  DEBUG_MSG("Opening Socket...");
  pre_state = kInitSocket;
  const fd_t xvc_fd_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
  if (xvc_fd_socket == kUnixFailed)
    goto pre_err;

  /* Conf opts of socket */
  DEBUG_MSG("SetSockOpt...");
  pre_state = kSetSocketOpt;
  const int kReUseAddrIsTrue = 1 ;
  if (setsockopt(xvc_fd_socket, SOL_SOCKET, SO_REUSEADDR, 
          &kReUseAddrIsTrue, sizeof(kReUseAddrIsTrue) ) 
      == kUnixFailed ) 
    goto pre_err;
    

  /* Set port for xvc-server */
  struct sockaddr_in socket_addr = {
    .sin_addr.s_addr = INADDR_ANY,
    .sin_family = AF_INET,
    .sin_port = htons(kPort)
  };
  
  /* Bind address and port to Socket */
  DEBUG_MSG("Binding...");
  pre_state = kBindSocket;
  socklen_t size_sock_addr = sizeof(socket_addr);
  if (bind(xvc_fd_socket, (struct sockaddr*) &socket_addr, 
            size_sock_addr) 
      == kUnixFailed ) 
    goto pre_err;

  /* Listen */
  DEBUG_MSG("Listing...");
  pre_state = kListenSocket;
  if (listen(xvc_fd_socket, kLenBacklog) == kUnixFailed) 
    goto pre_err;

  /* Only 1 eth_fd-fd need to wait */
  fd_t xvc_max_fd = xvc_fd_socket +1; 
  
  /* A connection (to prot-2542 of socket) in a set of fd */
  fd_set xvc_conn_set; 

  /* Countdown blocking mode */
  struct timeval tv_block_cd = { 
    .tv_sec = kEthConnTimeOutSec,
    .tv_usec = 0
  }; 

  enum IOState io_state = kStart;
  while (true) {
    FD_ZERO(&xvc_conn_set);
    FD_SET(xvc_fd_socket, &xvc_conn_set);
    fd_set rd = xvc_conn_set, wr = xvc_conn_set, except = xvc_conn_set;

    /* Wait event rd/wr/except from xvc_max_fd */
    const fd_t result_sel = select(xvc_max_fd, &rd, &wr, &except, &tv_block_cd);
    /* Check Result of select */
    if (result_sel == -1) {
      io_state = kSelectFail;
      goto io_err;
    } else if (result_sel == 0) {
      io_state = kSelectTimeOut;
      goto io_err;
    } 
    
    /* Scan all fd after select() returned */
    for (fd_t fd_iter = 0; fd_iter <= xvc_max_fd; fd_iter++) { 
      /* if find the socket which is we care */
      if (FD_ISSET(fd_iter, &rd) ) {
        if (fd_iter == xvc_fd_socket) {
          const fd_t newfd = accept(xvc_fd_socket, 
                              (struct sockaddr*) &socket_addr, 
                              &size_sock_addr);
          if (newfd == kUnixFailed) {
            ERROR_MSG("Failed to Accept New FD For Socket");
            exit(EXIT_FAILURE);
          } else {
            DEBUG_MSG("Accept");  
            const char kTcpNoDelayIsTrue = 1;
            /* Disable Nagle Algorithm */
            if (setsockopt(newfd, IPPROTO_TCP, TCP_NODELAY, 
                    &kTcpNoDelayIsTrue, sizeof(kTcpNoDelayIsTrue) ) == 
                kUnixFailed ) {
              ERROR_MSG("setsockopt error for TCP_NODELAY");
              exit(EXIT_FAILURE);
            } else {
              DEBUG_MSG("setsockopt successed for TCP_NODELAY");
              /* Replace old fd (without set to TCP_NODELAY) 
               * with new fd which can bobble up to top of fd_iter
               */
              if (newfd > xvc_max_fd)
                xvc_max_fd = newfd;
              FD_SET(newfd, &xvc_conn_set);
            } 
          }
        } else if (!JtagEthBridge(fd_iter, xvc_memobj) ) {
          DEBUG_MSG("Connection closed");
          close(fd_iter);
          FD_CLR(fd_iter, &xvc_conn_set);
        }        
      } else if (FD_ISSET(fd_iter, &except) ) {
          /* if except occured */
        ERROR_MSG("connection is except");
        exit(EXIT_FAILURE);
      } else {
        ERROR_MSG("Failure: Unknow FD_ISSET()");
        exit(EXIT_FAILURE);
      }
    }
  }
  exit(EXIT_SUCCESS);

pre_err:
  switch(pre_state) {
    case kInitUIOFD: 
      ERROR_MSG("Failed to Open UIO Device");
      break;
    case kInitJtagMMap: 
      ERROR_MSG("Failed to Mapping from mem to Jtag port ");
      break;
    case kInitSocket:      
      ERROR_MSG("Failed to Open Socket");
      break;
    case kSetSocketOpt: 
      ERROR_MSG("Failed to setsockopt");
      break;
    case kSetSocketPort: 
      ERROR_MSG("Buffer size exceeded"); 
      break;
    case kBindSocket: 
      ERROR_MSG("Failed to bind");
      break;
    case kListenSocket: 
      ERROR_MSG("Failed to listen");
      break;
    default:
      ERROR_MSG("Unknow error when preaction");
      break;
  }
  exit(EXIT_FAILURE);

io_err:
  switch(io_state) {
    case kSelectFail: 
      ERROR_MSG("Failed to Select");
      break;
    case kSelectTimeOut: 
      ERROR_MSG("Select is timeout");
      break;
    case kInitSocket:      
      ERROR_MSG("Failed to Open Socket");
      break;
    case kSetSocketOpt: 
      ERROR_MSG("Failed to setsockopt");
      break;
    case kSetSocketPort: 
      ERROR_MSG("Buffer size exceeded"); 
      break;
    case kBindSocket: 
      ERROR_MSG("Failed to bind");
      break;
    case kListenSocket: 
      ERROR_MSG("Failed to listen");
      break;
    default:
      ERROR_MSG("Unknow error when io");
      break;
  }
  exit(EXIT_FAILURE);
}

