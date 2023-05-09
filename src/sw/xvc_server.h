/**
 * @file xvc_server.h
 * @brief Headers(Definations) of xvc_server
 * @author dewei
 * @date 2021-2-2
 * @version 0.0.1
*/

#ifndef XVC_SERVER_H
#define XVC_SERVER_H


#include <stdint.h>
#include <stdbool.h>
#include <sys/types.h>

#include <unistd.h>

/**
 * @brief Type of file descriptor(fd) that POSIX defaults as int
 */
typedef int fd_t;

/**
 * @brief Type of buffer, recommend using char or unsigned char
 */
typedef uint8_t buf_t;

/**
 * @brief Data type for hold on JTAG Data
 */
typedef struct {
  uint32_t  length_offset;
  uint32_t  tms_offset;
  uint32_t  tdi_offset;
  uint32_t  tdo_offset;
  uint32_t  ctrl_offset;
} jtag_t;


/**
 * @brief state of general Unix manipulate returned
 */
enum Unixstate {
  kUnixSuccessful = 0,
  kUnixFailed = -1
};


/**
 * @brief State tag for JtagEthBridge func.
 */
enum JtagBridgeState {
  kJtagBridgeStart = 0,
  kWriteXVCInfo = 1,
  kSetSCK = 2,
  kRecvCmd = 3,
  kReadLength = 4,
  kChkBuf = 5,
  kReadData = 6,
  kWriteData = 7
};

/**
 * @brief State tag for main prgo: config UIO/EthFD/MMap
 */
enum PreactionState {
  kProgStart = 0,
  kInitUIOFD = 1,
  kInitJtagMMap = 2,
  kInitSocket = 3,
  kSetSocketOpt = 4,
  kSetSocketPort = 5,
  kBindSocket = 6,
  kListenSocket = 7
};



#endif