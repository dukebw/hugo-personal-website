---
title: "Programming massively parallel processors 🟩"
date: "2024-07-02"
toc: true
tags:
  - gpu
---

# Programming massively parallel processors

These are notes taken while working through the Programming massively parallel
processors (PMPP) book on CUDA.

## Chapter 1

[pg. 4, fig. 1.1]

## Chapter 5

- Rule of thumb: aggregated memory bandwidth from all register files across all
  SMs is 2 orders of magnitude greater than the total global memory bandwidth.
- Variables in registe files increase compute to global memory bandwidth ratio.
- Fewer instructions when variables are in registers.
  Consider the case when a variable is already in register r2:
  ```nvptx
  fadd r1, r2, r3
  ```
  versus the case where the variable is in global memory:
  ```nvptx
  ld r2, r4, offset
  fadd r1, r2, r3
  ```
- Energy used to access global memory is an order of magnitude higher than the
  energy used to access a register file.

- [pg. 100, Fig. 5.4]

- Shared memory: requires a load operation hence higher latency and lower
  bandwidth than registers.
  But much higher bandwidth than global memory.
  A form of scratchpad memory.

- Shared memory | Registers
  Shared by all threads in a block | Private to a thread

- [pg.100]

- Variable declaration | Memory | Scope | Lifetime
  Automatic variables other than arrays | Registers | Thread | Grid
  Automatic array variables | Local | Thread | Grid
  `__device__ __shared__ int` | Shared | Block | Grid
  `__device__ int` | Global | Grid | Application
  `__device__ __constant__ int` | Constant | Grid | Application

- Constant variables are stored in global memory but cached for efficient,
  parallel access.
  - Limited to 64KiB.

- Global variables:
  - Slow latency.
  - No synchronization across thread blocks other than atomics or terminating
    the kernel.
  - Can use fences to sync across thread blocks if the number of blocks is less
    than the number of SMs.
  - Often used to pass information from one kernel invocation to another.

- Pointers in CUDA device code point to addresses in global memory.

- [pg. 103, Sec. 5.3]

- Since shared memory is fast and small and global memory is slow and fast,
  tiling is used to process a shared memory sized tile of data at a time.
  The union of all tiles covers the data structure in global memory.
