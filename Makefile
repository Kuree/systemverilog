SV_SYNTAX=--syntax-definition syntax/systemverilog.xml

systemverilog.pdf: book/title.txt $(shell find book/**/*.md)
	pandoc ${SV_SYNTAX}  -o $@ $^
