SV_SYNTAX=--syntax-definition syntax/systemverilog.xml
FILTERS=pandoc-xnos
DOCKER_USER=--user 1000:1000

docker: book/title.txt $(shell find book/**/*.md)
	docker run --rm -v `(pwd)`:/systemverilog ${DOCKER_USER} keyiz/pandoc /systemverilog/scripts/build.sh


systemverilog.pdf: book/title.txt $(shell find book/**/*.md)
	pandoc ${SV_SYNTAX}  -o $@ $^ --filter ${FILTERS}


clean:
	rm -rf *.pdf
	make -C images clean
