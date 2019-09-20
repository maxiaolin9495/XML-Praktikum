<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="highscores">
		<html style="height:100%; font-family: 'Arial', 'Times New Roman'; font-size: 2vmin; overflow-wrap: break-word;">
			<head>
				<title>Southpark Blackjack - Highscores</title>
			</head>
			<body style="height:100%; margin: 0px; overflow: auto;">
				<div style="width: 100%; height: 10%;"/>
				<div style="width: 80%; height: 80%; margin-left: 10%; float: left; background-color: darkred;">
					<div style="width: 100%; height: 10%;"/>
					<div style="width: 90%; height: 75.94%; margin: auto; padding-top: 2%; background-color: darkgreen;
						overflow: auto;">
						<xsl:for-each select="./score">
							<div style="width: 90%; margin: 0% auto 2% auto; padding: 1%; background-color: darkred;
								overflow:auto;">
								<div style="width: 48%; margin-left: 1%; float: left; text-align: center;
									background-color: darkgreen; color: darkred;">
									<xsl:value-of select="./@name"/>
								</div>
								<div style="width: 48%; margin-left: 2%; float: left; text-align: center;
									background-color: darkgreen; color: darkred;">
									<xsl:value-of select="./@value"/>
								</div>
							</div>
						</xsl:for-each>
					</div>
					<div style="width: 100%; height: 10%;"/>
				</div>
				<div style="width: 10%; height: 80%; float: left;">
					<button onclick="location.href='../htmlforms';" type="button" style="width: 80%;
						margin: 0% 10% 0% 10%; background-color: black; color: white;"
						onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
						onmouseout="this.style.backgroundColor='black'; this.style.color='white'">
						Return!
					</button>
				</div>
				<div style="width: 100%; height: 10%;"/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
