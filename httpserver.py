#!/usr/bin/env python

import time
import BaseHTTPServer
import urlparse
import pprint

HOST_NAME = 'localhost'
PORT_NUMBER = 1935

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_HEAD(s):
        print 'AZDEBUG: HEAD'
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
    def do_GET(s):
        """Respond to a GET request."""
        print 'AZDEBUG: GET'
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
        s.wfile.write("<html><head><title>Title goes here.</title></head>")
        s.wfile.write("<body><p>This is a test.</p>")
        # If someone went to "http://something.somewhere.net/foo/bar/",
        # then s.path equals "/foo/bar/".
        p = urlparse.urlparse(s.path)
        if p.path == '/callback/':
            s.wfile.write("<table><tr><th>Key</th><th>Value</th></tr>")
            q = urlparse.parse_qs(p.query)
            for key in q:
                s.wfile.write("<tr><td>%s</td><td><tt>%s</tt></td></tr>" % (key, q[key][0]))
                # print '%s: %s' % (key, q[key][0])
            s.wfile.write("</table>")
        else:
            s.wfile.write("<p>You accessed path: %s</p>" % s.path)
        s.wfile.write("</body></html>")
    def do_POST(s):
        """Respond to a POST request."""
        print 'AZDEBUG: POST'
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()

        length = int(s.headers.getheader('content-length'))
        data = s.rfile.read(length)
        # print s.path
        # print
        # print s.headers
        # print
        # print repr(data)

if __name__ == '__main__':
    server_class = BaseHTTPServer.HTTPServer
    httpd = server_class((HOST_NAME, PORT_NUMBER), MyHandler)
    print time.asctime(), "Server Starts - %s:%s" % (HOST_NAME, PORT_NUMBER)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
    print time.asctime(), "Server Stops - %s:%s" % (HOST_NAME, PORT_NUMBER)
