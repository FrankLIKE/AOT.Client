/*******************************************************************************
* MSIL to LLVM IR Compiler
*
*
*******************************************************************************/
#include <iostream>
#include <string>
void Usage() { std::cout << "AOT.Client dcc MSIL Compiler." << std::endl; }

int main(int argc, char **argv) {
  if (argc < 2) {
    Usage();
    return 0;
  }
  return 0;
}
