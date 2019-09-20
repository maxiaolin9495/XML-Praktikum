# XML-Praktikum - Black Jack - Project

## Folder structure
<ul>
	<li>The "basexconf" folder contains a basic BaseX configuration.</li>
	<li>The "restxq" folder contains the BaseX RESTXQ files. Mostly, these are XQuery files in a complex structure.</li>
	<li>The "webapp" folder contains the BaseX WebApp files. This includes static files like SVGs, DTDs, and XSLs.</li>
</ul>

## Setup
To run this project, a working installation of BaseX is necessary. The "restxq/htmlforms" folder needs to be copied to the destination of BaseX's RESTXQPATH. Analogously, the "webapp/static/htmlforms" folder needs to be copied to the "static" folder which can be found at the destiation of BaseX's WEBPATH.

An empty BaseX database named "htmlforms" is needed.
