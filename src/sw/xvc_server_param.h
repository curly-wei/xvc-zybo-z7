/**
 * @file xvc_server_const.h
 * @brief Definations of constants(parameter) for xvc_server
 * @author dewei
 * @date 2021-2-10
 * @version 0.0.1
*/

#ifndef XVC_SERVER_CONST_H
#define XVC_SERVER_CONST_H


#include <stdint.h>
#include <stddef.h>

/**
 * @brief Path to JTAG (Physical) port, seems to /dev/uid**
 */
static const char kUIOPath[] = "/dev/uio0";

/**
 * @brief 
 * Size of Mapping to Memory for (Physical)  JTAG-Port, 
 * which designated by XVC-Server-Hardware (Zynq-processor-IP)
 */
static const size_t kMapSize = 0x10000;

/**
 * @brief Port of XVC-Server, which is designated by Xilinx-Vivado
 */
static const uint16_t kPort = 2542;

/**
 * @brief Google search to Backlog of sockect (picture)
 */
static const int kLenBacklog = 128;

/**
 * @brief Timeout value (sec) of connection to pending I/O from ethernet
 */
static const size_t kEthConnTimeOutSec = 30;

/**
 * @brief Size of r/w buffer
 */
static const size_t kBufferSize = 2048;

/**
 * @brief Size of command
 */
static const size_t kCmdSize = 16;

static const char kXVCInfo[] = "xvc_server_v1.0:2048\n";

#endif