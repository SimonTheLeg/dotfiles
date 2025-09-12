package main

import (
  "fmt"
  "os"
)

func main() {
  if err := execute(); err != nil {
    fmt.Println(err)
    os.Exit(1)
  }
}

func execute() error {
  return nil
}
