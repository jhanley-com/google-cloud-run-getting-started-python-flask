# google-cloud-run-getting-started-python-flask
<h4>Repository for my article: Google Cloud Run - Getting Started with Python and Flask</h4>
See my article for more details:<br />
https://www.jhanley.com/google-cloud-run-getting-started-with-python-and-flask/
<br />
<h2><a href="https://cloud.google.com/run/" target="_blank" rel="noopener noreferrer"><img class="alignleft wp-image-1158 size-medium" src="https://www.jhanley.com/wp-content/uploads/2019/05/awesome_cloud_run-300x150.jpg" alt="" width="300" height="150" /></a></h2>
<h2>Introduction</h2>
On August 15, 2018, Google released the Alpha release of Google Cloud Run. Many of us saw the potential and went to work learning this new platform. Everything serverless gets our attention. Cloud Run is Google's entry into serverless containers. On April 9, 2019, Cloud Run went into Beta and has lit on fire. To say that I am impressed is an understatement.

What is Google Cloud Run? Cloud Run is a managed compute platform for running stateless containers in the cloud. The only serious requirements are that your container must be invocable via HTTP requests and not require long running or background processes as they put the container to sleep in between HTTP requests. Cloud Run also makes deploying HTTPS and SSL certificates easy.
<h5>Key feature points:</h5>
<ul>
 	<li>Run HTTP apps and services</li>
 	<li>Simple developer experience</li>
 	<li>Fast auto-scaling</li>
 	<li>Scales to zero</li>
 	<li>Almost any language, any library, any runtime</li>
 	<li>HTTP and HTTPS</li>
 	<li>SSL certificates for your domain name</li>
 	<li>Integrated logging and monitoring - Stackdriver</li>
 	<li>Pay per use - no traffic equals no cost</li>
 	<li>Optional authentication</li>
</ul>
Cloud Run is a big brother to Cloud Functions. Both can do many of the same things. I prefer Cloud Run as I have control over the language, run-time libraries and operating system for my application. Just about anything that will run in a Docker container can be deployed to Cloud Run. Cloud Functions is still a favorite for small, tightly controlled microservices.

Cloud Run also supports Kubernetes, which I am not covering in this article. However, redeploying from Cloud Run to Cloud Run on GKE is a simple as adding one command line option. That is what I call elegant simplicity.

In this article, we will create a Python Flask web application and deploy into a Docker container. Then we will take this container and deploy to Cloud Run. Once we have everything working, we will create a domain name in our DNS server and deploy an SSL certificate.

This article covers development and deployment from a Windows 10 Professional desktop. Linux is similar but not covered in this article.

We will work with several products and services. Having a basic understanding will be helpful.
<ul>
 	<li><a href="https://www.python.org/" target="_blank" rel="noopener noreferrer">Python 3</a> and <a href="http://flask.pocoo.org/">Flask</a></li>
 	<li><a href="https://www.docker.com/" target="_blank" rel="noopener noreferrer">Docker</a></li>
 	<li><a href="https://cloud.google.com/cloud-build/" target="_blank" rel="noopener noreferrer">Google Cloud Build</a></li>
 	<li><a href="https://cloud.google.com/container-registry/" target="_blank" rel="noopener noreferrer">Google Cloud Container Registry</a></li>
 	<li><a href="https://cloud.google.com/run/" target="_blank" rel="noopener noreferrer">Google Cloud Run</a></li>
</ul>
The final result will be a simple web application that responds at <a href="https://flask-python-example.jhanley.dev" target="_blank" rel="noopener noreferrer">https://flask-python-example.jhanley.dev</a>. Your endpoint will be different.
<h5>Assumptions:</h5>
<ul>
 	<li>You have gcloud installed and configured with the correct credentials and project</li>
 	<li>You have Docker installed</li>
 	<li>You have Python 3 installed</li>
</ul>
If you do not have Docker or do not want to install it, you can still follow the Google Cloud sections and build and run a container in Cloud Run. You just cannot build and run a local Docker container. You don't even need Python installed.<span id="selectionBoundary_1558070976838_7211153326859114" class="rangySelectionBoundary" style="line-height: 0; display: none;"></span>
<h5>Additional information</h5>
Google has several good videos to introduce you to Cloud Run. Here are several I like and their running time:
<ul>
 	<li><a href="https://youtu.be/nJ0L28ZfmUA" target="_blank" rel="noopener noreferrer">Build and deploy with Cloud Run</a> - 4:24</li>
 	<li><a href="https://youtu.be/RVdhyprptTQ" target="_blank" rel="noopener noreferrer">Differences between Cloud Run and Cloud Run on GKE</a> - 5:23</li>
 	<li><a href="https://youtu.be/3OP-q55hOUI" target="_blank" rel="noopener noreferrer">Cloud Run QuickStart - Docker to Serverless</a> - 7:49</li>
 	<li><a href="https://youtu.be/xVuuvZkYiNM" target="_blank" rel="noopener noreferrer">Run Containers on GCP's Serverless Infrastructure (Cloud Next '19)</a> - 48:32</li>
</ul>
An often overlooked item is the size of your containers. You want them as small as possible to minimize container cold start times. This video is a nice introduction to this:
<ul>
 	<li><a href="https://youtu.be/wGz_cbtCiEA" target="_blank" rel="noopener noreferrer">Building Small Containers (Kubernetes Best Practices)</a> - 8:44</li>
</ul>
Do not forget container security. Make sure that your containers have the proper patches and have been scanned for vulnerabilities.
<ul>
 	<li><a href="https://youtu.be/CcpVrKigP_k" target="_blank" rel="noopener noreferrer">Container Registry Vulnerability Scanning</a> - 2:29</li>
</ul>
<h2>Download Git Repository</h2>
Update: May 16, 2019

I have published the files for this article on GitHub. <a href="https://github.com/jhanley-com/google-cloud-run-getting-started-python-flask" target="_blank" rel="noopener noreferrer">https://github.com/jhanley-com/google-cloud-run-getting-started-python-flask</a>

License: <a href="https://github.com/jhanley-com/google-cloud-run-getting-started-python-flask/blob/master/LICENSE" target="_blank" rel="noopener noreferrer">MIT License</a>

Clone my repository to your system:
<pre class="lang:default decode:true" title="Clone Repository">git clone https://github.com/jhanley-com/google-cloud-run-getting-started-python-flask.git</pre>
<h2>Develop the Python Flask Application</h2>
For this article, we will write a simple Python Flask application that displays "Hello Google Cloud Run World!" with a link to the Cloud Run website. We will write and test this from our Windows 10 desktop. The steps are similar for Linux and are not covered in this article.

For this application we just need Flask. Create the requirements.txt file with this content:
<pre class="lang:default decode:true" title="requirements.txt">Flask==1.0.2</pre>
Install/verify that that Flask is installed:
<pre class="lang:default decode:true " title="Installation">pip install -r requirements.txt</pre>
Let's look at a simple Flask application. We will not be using this example, this is to simplify understanding Flask. This is a seven-line web server application! This example will listen on 127.0.0.1 port 5000:
<pre class="lang:default decode:true" title="Simple Hello World Example">from flask import Flask
app = Flask(__name__)
@app.route("/")
def home():
    return "Hello, World!"
if __name__ == "__main__":
    app.run(debug=True)</pre>
We will use an expanded version. Create the application file app.py with this content:
<pre class="lang:default decode:true" title="app.py">import os
import logging

from flask import Flask

# Change the format of messages logged to Stackdriver
logging.basicConfig(format='%(message)s', level=logging.INFO)

app = Flask(__name__)

@app.route('/')
def home():
	html = """
&lt;html&gt;
 &lt;head&gt;
  &lt;title&gt;
   Google Cloud Run - Sample Python Flask Example
  &lt;/title&gt;
 &lt;/head&gt;
 &lt;body&gt;
  &lt;p&gt;Hello Google Cloud Run World!&lt;/p&gt;
  &lt;a href="https://cloud.google.com/run/" target="_blank"&gt;Google Cloud Run Website&lt;/a&gt;
 &lt;/body&gt;
&lt;/html&gt;
"""
	return html

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
</pre>
Execute this code:
<pre class="lang:default decode:true " title="Execute">python app.py</pre>
Click this link or open a web browser to <a href="http://localhost:8080/" target="_blank" rel="noopener noreferrer">http://localhost:8080/</a>

You should see a page similar to this:

<img class="alignnone size-full wp-image-1028" src="https://www.jhanley.com/wp-content/uploads/2019/05/website_localhost.jpg" alt="" width="379" height="175" />

Press CTRL-C to kill the Flask web server.

I will not go into detail about Flask as there are extensive documentation and examples on the Internet. At this point, we have created a simple web server and ran it on our local desktop. I like to develop and test as much as possible locally as this is easier and faster than waiting for deployments to complete.<span id="selectionBoundary_1557517889867_5106413735301853" class="rangySelectionBoundary" style="line-height: 0; display: none;"></span>
<h2>Develop the Docker Container</h2>
The next step is to take the website application and deploy it as a Docker container.

Create the Dockerfile file with this content:
<pre class="lang:default decode:true" title="Dockerfile"># Use the official Python 3 image.
# https://hub.docker.com/_/python
#
# python:3 builds a 954 MB image - 342.3 MB in Google Container Registry
# FROM python:3
#
# python:3-slim builds a 162 MB image - 51.6 MB in Google Container Registry
# FROM python:3-slim
#
# python:3-alpine builds a 97 MB image - 33.2 MB in Google Container Registry
FROM python:3-alpine

# RUN apt-get update -y
# RUN apt-get install -y python-pip

COPY . /app

# Create and change to the app directory.
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod 444 app.py
RUN chmod 444 requirements.txt

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run the web service on container startup.
CMD [ "python", "app.py" ]</pre>
Notice I have some lines commented out. The reason is that I like to start with a full container build (FROM python:3) and when deploying switch to a minimal build (FROM python:3-alpine). Sometimes I need to connect inside the container to debug, install tools, etc. Before deploying production code, build the smallest container you can. This will decrease costs, minimize the testing footprint, reduce data transfer time to start the container and improve security.

Build the container:
<pre class="lang:default decode:true " title="Build the Container">docker build -t sample-flask-example:latest .</pre>
You will receive a security warning from Docker on Windows:
<pre class="wrap:true lang:default decode:true" title="Security warning">SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.</pre>
This issue is handled in the Dockerfile with these lines:
<pre class="lang:default decode:true " title="Security fix">RUN chmod 444 app.py
RUN chmod 444 requirements.txt</pre>
The problem is that the Dockerfile COPY statements add execution permission to files. The chmod commands change the file permissions back to read-only. If you forget to do this, you will have Python execute errors.

Next, run the container and verify that everything works.
<pre class="lang:default decode:true " title="Run the Container">docker run -it --rm -p 8080:8080 sample-flask-example:latest</pre>
Click this link or open a web browser to <a href="http://localhost:8080/" target="_blank" rel="noopener noreferrer">http://localhost:8080/</a>

You should see the same content again.

Press CTRL-C to kill the container.
<h2>Build the Container with Cloud Build</h2>
Everything we have done up to this point has not involved Google Cloud. Now we will switch and build our container in the cloud as the first step to deploy with Cloud Run.<span id="selectionBoundary_1557518804879_2662153321457166" class="rangySelectionBoundary" style="line-height: 0; display: none;"></span>

Build the container using Cloud Build and store in Cloud Container Registry. Replace my-project with your Google Cloud Project ID:
<pre class="lang:default decode:true " title="Build Container">gcloud builds submit --tag gcr.io/my-project/sample-flask-example</pre>
Once the build completes, you can list the containers is Container Registry:
<pre class="lang:default decode:true " title="List Containers">gcloud container images list</pre>
<h2>Deploy the Container to Cloud Run</h2>
Deploy the container from Container Registry to Cloud Run. Replace my-project with your Google Cloud Project ID:
<pre class="lang:default decode:true" title="Deploy to Cloud Run">gcloud beta run deploy sample-flask-example --image gcr.io/my-project/sample-flask-example --allow-unauthenticated</pre>
When this command completes, you will see a message similar to:
<pre class="wrap:true lang:default decode:true" title="Message">Service [sample-flask-example] revision [sample-flask-example-00001] has been deployed and is serving traffic at https://sample-flask-example-x5yqob7qaq-uc.a.run.app</pre>
Make a note of the endpoint in the message. Open a new browser and enter the URL.
<pre class="lang:default decode:true" title="URL Endpoint">https://sample-flask-example-x5yqob7qaq-uc.a.run.app</pre>
<h2>Create a Custom Domain and Certificate</h2>
If you are just creating an API, then making your Cloud Run instance easily accessible is not important. For websites, customers will expect a URL that is recognizable. I don't like to click on weird URLs - you never know what is behind them. So, let's go thru the process to create a custom domain and SSL certificate and make our website available as a subdomain.

Open a web browser and go to the Google Cloud Run console <a href="https://console.cloud.google.com/run" target="_blank" rel="noopener noreferrer">https://console.cloud.google.com/run</a>. Click on Manage Custom Domains.

<img class="alignnone size-large wp-image-1034" src="https://www.jhanley.com/wp-content/uploads/2019/05/cloud_run_console-1024x118.jpg" alt="" width="840" height="97" />

Click Add Mapping. Select the Cloud Run service we just deployed. Select your domain name. Enter your subdomain. In this example "flask-python-example".

If your domain name does not appear, select "Verify a new domain ..." and follow the prompts.

<img class="alignnone size-full wp-image-1040" src="https://www.jhanley.com/wp-content/uploads/2019/05/add_domain_mapping.jpg" alt="" width="774" height="666" />

Click Continue. The next step is to create a CNAME in your DNS server with the information from this screen:

<img class="alignnone size-full wp-image-1041" src="https://www.jhanley.com/wp-content/uploads/2019/05/cname.jpg" alt="" width="774" height="600" />

You will need to wait about ten to thirty minutes for Google to deploy the SSL certificate and for your DNS server to start responding to requests for the new domain name.

Open a web browser and go to your new domain. For this example: <a href="https://flask-python-example.jhanley.dev" target="_blank" rel="noopener noreferrer">https://flask-python-example.jhanley.dev</a>.

In a future article, I will cover HTTPS and SSL for Cloud Run including HTTPS redirection, secure headers, HSTS and some suggestions for Google to improve Cloud Run security.
<h2>Summary</h2>
Congratulations, you have deployed a simple containerized website to Google Cloud Run.

There are many more features of Google Cloud Run we have not covered in this introductory article. In future articles, I will cover more details including combining Cloud Run with other Google Cloud services for automation.

We can combine Cloud Run with other Google Cloud services, such as Cloud Storage and Pub/Sub to monitor the security settings on storage objects. This just scratches the surface of what we can do beyond just websites.

&nbsp;

Date created: May 10, 2019
<br />
Last updated: May 16, 2019
