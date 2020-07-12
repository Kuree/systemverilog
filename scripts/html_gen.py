import sys
import os
from html.parser import HTMLParser as HParser
import shutil


class HTMLNode:
    def __init__(self, tag):
        assert tag
        self.tag = tag
        self.data = ""
        self.children = []
        self.attr = {}
        self.parent = None

        self.pos = None
        self.str = ""

    def __repr__(self):
        return self.str


class HTMLParser(HParser):
    def __init__(self, raw_data):
        super().__init__()
        self.root = HTMLNode("root")
        self.current_node = self.root
        self.raw_lines = raw_data.split("\n")
        self.feed(raw_data)


    def handle_starttag(self, tag, attrs):
        node = HTMLNode(tag)
        node.parent = self.current_node
        self.current_node.children.append(node)
        self.current_node = node
        attr = {}
        for item in attrs:
            attr[item[0]] = item[1] if len(item) == 2 else item[1:]
        node.attr = attr
        node.pos = self.getpos()

    def handle_endtag(self, tag):
        assert tag == self.current_node.tag
        pos = self.getpos()
        start_ln, start_pos = self.current_node.pos
        end_ln, end_pos = self.getpos()
        if end_ln != start_ln:
            end_ln + 1

        s = []
        for ln in range(start_ln - 1, end_ln):
            line = self.raw_lines[ln]
            if ln == start_ln - 1:
                s.append(line[start_pos:])
            elif ln == end_ln:
                s.append(line[:end_pos])
            else:
                s.append(line)
        self.current_node.str = "\n".join(s)

        self.current_node = self.current_node.parent

    def handle_data(self, data):
        self.current_node.data = data


def has_tag(line, tag):
    tag_str = "<{0}".format(tag)
    tag_str_len = len(tag_str)
    return len(line) >= tag_str_len and line[0:tag_str_len] == tag_str


class HTMLNodeVisitor:
    def visit(self, node):
        tag = node.tag
        method_name = "visit_" + tag
        if self.has_method(method_name):
            getattr(self, method_name)(node)
        for child in node.children:
            self.visit(child)

    def has_method(self, name):
        return hasattr(self, name) and callable(getattr(self, name))


class HTMLVisitor(HTMLNodeVisitor):
    def __init__(self):
        self.css = []
        self.body = None
        self.title = ""

    def visit_style(self, node):
        self.css.append(node.data)

    def visit_body(self, node):
        self.body = node

    def visit_title(self, node):
        self.title = node.data


class Content:
    def __init__(self, body):
        self.chapters = {}

        content = []
        chapter_name = ""
        chapter_id = ""
        idx = 0
        for node in body.children:
            if node.tag == "header":
                continue
            if node.tag == "h1":
                if idx != 0:
                    assert chapter_name
                    self.chapters[chapter_id] = (chapter_name, content)
                    content = []
                chapter_name = node.data
                chapter_id = node.attr["id"]
            content.append(str(node))

            idx += 1
        # the last one
        self.chapters[chapter_id] = (chapter_name, content)


def read_out_template(root_dir):
    template = os.path.join(root_dir, "templates", "base.html")
    with open(template) as f:
        return f.read()


def produce_menu_link(chapters):
    result = []
    for name, content in chapters.items():
        ch_name = content[0]
        s = '<li class="pure-menu-item"><a href="/{0}.html" class="pure-menu-link">{1}</a></li>'.format(name,
                                                                                                        ch_name)
        result.append(s)
    return '\n'.join(result)


def copy_assets(root_dir, output_dir):
    if not os.path.isdir(output_dir):
        os.mkdir(output_dir)
    assets_dir = os.path.join(root_dir, "assets")
    dst_dir = os.path.join(output_dir, "assets")
    if os.path.isdir(dst_dir):
        shutil.rmtree(dst_dir)
    shutil.copytree(assets_dir, dst_dir)


def output_css(output_dir, css):
    dst_path = os.path.join(output_dir, "assets", "css", "pandoc.css")
    with open(dst_path, "w+") as f:
        content = "\n".join(css)
        f.write(content)


def output_html(output_dir, chapters, template_data, title):
    menu = produce_menu_link(chapters)
    menu_name = "Content"
    for name, content in chapters.items():
        ch_title, content = content
        c_s = "\n".join(content)
        s = template_data.format(title=title,
                                 menu_name=menu_name,
                                 menu_list=menu,
                                 content=c_s)
        dst = os.path.join(output_dir, "{0}.html".format(name))
        with open(dst, "w+") as f:
            f.write(s)


def main():
    args = sys.argv
    assert len(args) == 3, \
           "Usage: {0} <index.html> <output_dir>".format(args[0])
    index_html = args[1]
    output_dir = args[2]

    with open(index_html) as f:
        raw_data = f.read()

    parser = HTMLParser(raw_data)

    # find the html content
    html_visitor = HTMLVisitor()
    html_visitor.visit(parser.root)

    # read out the content
    content = Content(html_visitor.body)
    assert (html_visitor.title)

    # get root_dir
    root_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
    template_data = read_out_template(root_dir)

    # copy assets
    copy_assets(root_dir, output_dir)

    # output css
    output_css(output_dir, html_visitor.css)

    # output html
    output_html(output_dir, content.chapters, template_data, html_visitor.title)


if __name__ == "__main__":
    main()
