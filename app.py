import os
import logging

from flask import Flask

# Change the format of messages logged to Stackdriver
logging.basicConfig(format='%(message)s', level=logging.INFO)

app = Flask(__name__)

@app.route('/')
def home():
	html = """
<html>
 <head>
  <title>
   Google Cloud Run - Sample Python Flask Example
  </title>
 </head>
 <body>
  <p>Hello Google Cloud Run World!</p>
  <a href="https://cloud.google.com/run/" target="_blank">Google Cloud Run Website</a>
 </body>
</html>
"""
	return html

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
