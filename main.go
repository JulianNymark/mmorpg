package main

import (
	"encoding/json"
	"fmt"
	"html"
	"log"
	"net/http"
)

type move_s struct {
	Target []int `json:"target"`
}

func root(w http.ResponseWriter, r *http.Request) {
	// template pls
	fmt.Fprintf(w, "<html><head></head><body>")
	fmt.Fprintf(w, "<ul>")
	fmt.Fprintf(w, "<li>")
	fmt.Fprintf(w, "<a href='/move'>/move</a>")
	fmt.Fprintf(w, "</li>")
	fmt.Fprintf(w, "</ul>")
	fmt.Fprintf(w, "</body></html>")
}

func connect(w http.ResponseWriter, r *http.Request) {
	// template pls
	fmt.Fprintf(w, "<html><head></head><body>")
	fmt.Fprintf(w, "<ul>")
	fmt.Fprintf(w, "<li>")
	fmt.Fprintf(w, "<a href='/move'>/move</a>")
	fmt.Fprintf(w, "</li>")
	fmt.Fprintf(w, "</ul>")
	fmt.Fprintf(w, "</body></html>")
}

func move(w http.ResponseWriter, r *http.Request) {
	log.Println(r.Method)
	if r.Method != "POST" {
		fmt.Fprintf(w, "<html><head></head><body>")
		fmt.Fprintf(w, "<h1>must use POST with JSON encoded formdata!</h1>")
		fmt.Fprintf(w, "<h2>example:</h2>")

		exampleStruct := &move_s{
			[]int{31, 42},
		}

		bytes_json, err := json.MarshalIndent(exampleStruct, "", "  ")
		if err != nil {
			log.Fatal(err)
		}
		fmt.Fprintf(w, "<pre>%s</pre>", string(bytes_json))
		fmt.Fprintf(w, "</body></html>")
	}

}

func position(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "100, 200", html.EscapeString(r.URL.Path))
}

func main() {
	http.HandleFunc("/", root)
	http.HandleFunc("/move", move)
	http.HandleFunc("/connect", connect)
	http.HandleFunc("/position", position)
	log.Println("server running...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
