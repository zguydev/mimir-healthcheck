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
	if port < 1 || port > 65535 {
		fmt.Fprintln(os.Stderr, "port argument must be between 1 and 65535")
		os.Exit(1)
	}

	url := fmt.Sprintf("http://127.0.0.1:%d/ready", port)
	resp, err := http.Get(url)
	if err != nil {
		fmt.Fprintln(os.Stderr, "healthcheck: request failed:", err)
		os.Exit(1)
	}
	defer func() {
		_ = resp.Body.Close()
	}()

	const limit = 64 * 1024
	body, err := io.ReadAll(io.LimitReader(resp.Body, limit))
	if err != nil {
		fmt.Fprintln(os.Stderr, "healthcheck: failed to read response body:", err)
		os.Exit(1)
	}

	fmt.Println(string(body))

	if resp.StatusCode != http.StatusOK {
		os.Exit(1)
	}
	os.Exit(0)
}
