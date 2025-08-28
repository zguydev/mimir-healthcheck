package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
)

func main() {
	var port int
	flag.IntVar(&port, "port", 9009, "Mimir port")
	flag.Parse()
	if port < 0 || port > 65535 {
		panic("port must be between 0 and 65535")
	}

	url := fmt.Sprintf("http://localhost:%d/ready", port)
	resp, err := http.Get(url)
	if err != nil {
		fmt.Printf("Request failed: %v", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("Failed to read response: %v", err)
		os.Exit(1)
	}

	fmt.Print(string(body))
	if resp.StatusCode == http.StatusOK {
		os.Exit(0)
	}
	os.Exit(1)
}
