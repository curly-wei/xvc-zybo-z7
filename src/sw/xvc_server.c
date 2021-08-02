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

/**
 * @brief Macro function which can get the max value between 2 values
 */
#define MAX(a,b) \
  ((a)>(b)?(a):(b))

#ifndef RELEASE
  #include <errno.h>
  extern int errno ;
  #define XVC_ERROR_MSG(msg_str) XVC_ERROR_MSG_DETAIL(msg_str)
  #define DEBUG_MSG(msg_str) printf("%s\n",msg_str)
#else
  #define XVC_ERROR_MSG(msg_str) XVC_ERROR_MSG_SIMPLE(msg_str)
  #define DEBUG_MSG(msg_str)
#endif 


/**
 * @brief Simply stdout of error message
 */
#define XVC_ERROR_MSG_SIMPLE(msg_str) \
  perror(msg_str)

/**
 * @brief 
 * More detailing error messages, which
 * contained file-name and #-of-line and errno-strings
 */
#define XVC_ERROR_MSG_DETAIL(msg_str) \
  fprintf(stderr, "%s: %s\n, at #%d, file: %s\n", \
  (msg_str), strerror(errno), __LINE__, __FILE__)

/**
 * @brief Status of general Unix manipulate returned
 */
enum UnixStatus {
  kUnixSuccessful = 0,
  kUnixFailed = -1
};

/**
 * @brief Result of select()
 */
enum SelectResult {
  kSelectTimeOut = 0,
  kSelectFailed = -1
};

/**
 * @brief Read-in command from fd to buffer 
 * 
 * @param fd File descriptor(fd)
 * @param target Buffer for command content
 * @param target_len target length to read (Byte)
 * @return true Result is successed
 * @return false Any error in the result
 */
static inline bool StreamRead(const fd_t fd, buf_t* target, size_t target_len) {
  buf_t* temp = target;
  while (target_len) {
		ssize_t n_byte_read = read(fd, temp, target_len); // ssize_t != int
		if (n_byte_read <= (ssize_t) 0) // ssize_t [-1 .. +INT_MAX] on linux
			return false;
		temp += n_byte_read; //C11, 6.5.6/P8 and 6.2.5/P17
		target_len -= n_byte_read;
	}
	return true;
}

/**
 * @brief Forwaed ehternet data to jtag (or inversed direction)
 * @param eth File Descriptor of Ehernet (socker)
 * @param jtag Memory Map of Jtag Location
 * @return true Result is successed
 * @return false Any error in the result
 */
static inline bool JtagEthBridge(const fd_t eth, volatile jtag_t* jtag) {
  while (true) {
    buf_t cmd[kCmdSize];
    buf_t buffer[kBufferSize], result[kBufferSize/2];
    memset(cmd, 0, kCmdSize);

    if (!StreamRead(eth, cmd, 2) )
      return true;
    
    /* Read and judge command */
    if (memcmp(cmd, "ge", 2) == (int) 0 ) {
      if (!StreamRead(eth, cmd, 6) ) 
        return true;
      memcpy(result, kXVCInfo, strlen(kXVCInfo) );

    } else if (memcmp(cmd, "se", 2) == (int) 0) {

    } else if (memcmp(cmd, "sh", 2) == (int) 0) {
      
    } else {

    }
    

  }

};

int main() {
  DEBUG_MSG("Starting XVC Server");
  
  /* init fd to uio */
  const fd_t xvc_fd_uio = open(kUIOPath, O_RDWR);
  if (xvc_fd_uio == kUnixFailed) {
    XVC_ERROR_MSG("Failed to Open UIO Device");
    exit(EXIT_FAILURE);
  } else {
    /* Don't delete here or others DEBUG_MSG() 
     * Because here can be optimize by gcc
     * when you compile with release mode 
     * see https://godbolt.org/z/f6jPPG
     */
    DEBUG_MSG("UIO opened");
  }

  /* Mapping jtag memory from somewhere of memory to uio_port */
  volatile jtag_t* xvc_jtag_mem_loc = (volatile jtag_t*) mmap(
      NULL, kMapSize, PROT_READ | PROT_WRITE, 
      MAP_SHARED, xvc_fd_uio, 0);
  if (xvc_jtag_mem_loc == MAP_FAILED) {
    XVC_ERROR_MSG("Failed to Mapping from mem to Jtag port ");
    exit(EXIT_FAILURE);
  } else {
    DEBUG_MSG("mmap successed");
  }

  /* init fd to socket, use TCP mode */
  const fd_t xvc_fd_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP); 
  if (xvc_fd_socket == kUnixFailed) {
    XVC_ERROR_MSG("Failed to Open Socket");
    exit(EXIT_FAILURE);
  } else {
    DEBUG_MSG("Socket opened");
  }

  /* Conf opts of socket */
  const int kReUseAddrIsTrue = 1 ;
  if (setsockopt(xvc_fd_socket, SOL_SOCKET, SO_REUSEADDR, 
          &kReUseAddrIsTrue, sizeof(kReUseAddrIsTrue) ) == 
      kUnixFailed 
  ) {
    XVC_ERROR_MSG("Failed to setsockopt");
    exit(EXIT_FAILURE);
  } else {
    DEBUG_MSG("setsockopt successed");
  }

  /* Set port for xvc-server */
  struct sockaddr_in socket_addr = {
    .sin_addr.s_addr = INADDR_ANY,
    .sin_family = AF_INET,
    .sin_port = htons(kPort)
  };
  
  /* Bind address and port to Socket */
  socklen_t size_sock_addr = sizeof(socket_addr);
  if (bind(xvc_fd_socket, (struct sockaddr*) &socket_addr, 
            size_sock_addr) == 
      kUnixFailed
  ) {
    XVC_ERROR_MSG("Failed to bind");
    exit(EXIT_FAILURE);
  } else {
    DEBUG_MSG("bind successed");
  }
  
  /* Listen */
  if (listen(xvc_fd_socket, kLenBacklog) == kUnixFailed) {
    XVC_ERROR_MSG("Failed to listen");
    exit(EXIT_FAILURE);
  } else {
    DEBUG_MSG("listen successed");
  }

  /* Only 1 eth-fd need to wait */
  fd_t xvc_max_fd = xvc_fd_socket +1; 
  
  /* A connection (to prot-2542 of socket) in a set of fd */
  fd_set xvc_conn_set; 

  /* Countdown blocking mode */
  struct timeval tv_block_cd = { 
    .tv_sec = kEthConnTimeOutSec,
    .tv_usec = 0
  }; 
  while (true) {
    FD_ZERO(&xvc_conn_set);
    FD_SET(xvc_fd_socket, &xvc_conn_set);
    fd_set rd = xvc_conn_set, wr = xvc_conn_set, except = xvc_conn_set;

    /* Wait event rd/wr/except from xvc_max_fd */
    const fd_t result_sel = select(xvc_max_fd, &rd, &wr, &except, &tv_block_cd);
    /* Check Result of select */
    if (result_sel == kSelectFailed) {
      XVC_ERROR_MSG("Failed to Select");
      exit(EXIT_FAILURE);
    } else if (result_sel == kSelectTimeOut) {
      XVC_ERROR_MSG("Time out to Select");
      exit(EXIT_FAILURE);
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
            XVC_ERROR_MSG("Failed to Accept New FD For Socket");
            exit(EXIT_FAILURE);
          } else {
            DEBUG_MSG("Accept");  
            const char kTcpNoDelayIsTrue = 1;
            /* Disable Nagle Algorithm */
            if (setsockopt(newfd, IPPROTO_TCP, TCP_NODELAY, 
                    &kTcpNoDelayIsTrue, sizeof(kTcpNoDelayIsTrue) ) == 
                kUnixFailed ) {
              XVC_ERROR_MSG("setsockopt error for TCP_NODELAY");
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
        } else if (FD_ISSET(fd_iter, &except) ) {
          /* if except occured */
          XVC_ERROR_MSG("connection is except");
          exit(EXIT_FAILURE);
        } else {
          JtagEthBridge(fd_iter, xvc_jtag_mem_loc);
        }
      }
    }
  }
}

