<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="state">
        <html style="margin: 0px; padding: 0px; height:100%;">
            <head>
                <title>Southpark Blackjack</title>
            </head>
            <body style="margin: 0px; padding: 0px; height:100%;">
                <div style="width: 80%; height: 100%; margin: auto; background-image: url(./svgDateis/playTable.svg); background-size: 100% 100%;">
                    <xsl:apply-templates />
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="deck">
        <div style="width: 20%; height: 28%; float: left;">
            <div style="width: 84%; margin: 8%;">
                Deck
            </div>
            <div style="width: 84%; margin: 8%;">
                <div style="width: 21.4%; float: left;">
                    <svg width="100%" height="auto" viewBox="0 0 48 66" version="1.1" xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <image x="0" y="0" width="48" height="66" xlink:href="./svgDateis/Backside.png"/>
                    </svg>
                </div>
                <div style="width: 21.4%; margin-left: -15.4%; float: left;">
                    <svg width="100%" height="auto" viewBox="0 0 48 66" version="1.1" xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <image x="0" y="0" width="48" height="66" xlink:href="./svgDateis/Backside.png"/>
                    </svg>
                </div>
                <div style="width: 21.4%; margin-left: -15.4%; float: left;">
                    <svg width="100%" height="auto" viewBox="0 0 48 66" version="1.1" xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink">
                        <image x="0" y="0" width="48" height="66" xlink:href="./svgDateis/Backside.png"/>
                    </svg>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="dealer">
        <div style="width: 80%; height: 28%; float: left;">
            <div style="width: 96%; margin: 2%;">
                Dealer
            </div>
            <div style="width: 96%; margin: 2%;">
                <xsl:call-template name="DealerCard" />
            </div>
        </div>
    </xsl:template>
    <xsl:template match="player">
        <div style="width: 12%; height: 71%; margin-left: 2%; float: left;">
            <div style="width: 100%; height: 3.5%;">
                <xsl:value-of select="@name"/>
            </div>
            <div style="width: 100%; height: 3.5%;">
                Deposit: <xsl:value-of select="@deposit"/>
            </div>
            <xsl:for-each select="hand">
                <div style="width: 100%; height: 30%; margin-bottom: 1%;">
                    <div style="width: 100%; margin-top: 5%; text-align: center;">
                        Box: <xsl:value-of select="@box" />
                    </div>
                    <div style="width: 100%; margin-top: 9%;">
                        <xsl:call-template name="PlayerCard" />
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="DealerCard">
        <xsl:for-each select="card[@isHidden='true']">
            <div style="width: 4.9%; margin-right: -3.55%; float: left;">
                <svg width="100%" height="auto" viewBox="0 0 160 220" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                <image x="0" y="0" width="160" height="220" xlink:href="./svgDateis/Backside.png"/>
                </svg>
            </div>
        </xsl:for-each>
        <xsl:for-each select="card[@isHidden='false']">
            <div style="width: 4.9%; margin-right: -3.55%; float: left;">
                <svg width="100%" height="auto" viewBox="0 0 160 220" version="1.1" xmlns="http://www.w3.org/2000/svg"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                    <image x="0" y="0" width="160" height="220" xlink:href="./svgDateis/cardBackground.svg"/>
                    <image x="60" y="90" width="40" height="40" xlink:href="" >
                        <xsl:attribute name="xlink:href" >./svgDateis/<xsl:value-of select="@cardColour"/>.svg</xsl:attribute>
                    </image>
                    <image x="10" y="15" width="40" height="40" xlink:href="" >
                        <xsl:attribute name="xlink:href">./svgDateis/<xsl:choose><xsl:when test="@cardColour = 'Spades'">Black</xsl:when><xsl:when test="@cardColour = 'Clubs'">Black</xsl:when><xsl:otherwise>Red</xsl:otherwise></xsl:choose><xsl:value-of select="@cardValue"/>.svg</xsl:attribute>
                    </image>
                    <g transform="translate(30,35) rotate(180) translate(-125, -180)" >
                        <image x="10" y="15" width="40" height="40" xlink:href=""  >
                            <xsl:attribute name="xlink:href">./svgDateis/<xsl:choose><xsl:when test="@cardColour = 'Spades'">Black</xsl:when><xsl:when test="@cardColour = 'Clubs'">Black</xsl:when><xsl:otherwise>Red</xsl:otherwise></xsl:choose><xsl:value-of select="@cardValue"/>.svg</xsl:attribute>
                        </image>
                    </g>
                </svg>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="PlayerCard">
        <!-- This code is not needed anymore as players' cards are always visible:
            <xsl:for-each select="card[@isHidden='true']">
                <div style="width: 25%; margin-right: -18%; float: left;">
                    <svg width="100%" height="auto" viewBox="0 0 160 220" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                        <image x="0" y="0" width="160" height="220" xlink:href="./svgDateis/Backside.png"/>
                    </svg>
                </div>
            </xsl:for-each>
        -->
        <xsl:for-each select="card[@isHidden='false']">
            <div style="width: 30%; margin-right: -21.6%; float: left;">
                <svg width="100%" height="auto" viewBox="0 0 160 220" version="1.1" xmlns="http://www.w3.org/2000/svg"
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                    <image x="0" y="0" width="160" height="220" xlink:href="./svgDateis/cardBackground.svg"/>
                    <image x="60" y="90" width="40" height="40" xlink:href="" >
                        <xsl:attribute name="xlink:href" >./svgDateis/<xsl:value-of select="@cardColour"/>.svg</xsl:attribute>
                    </image>
                    <image x="10" y="15" width="40" height="40" xlink:href="" >
                        <xsl:attribute name="xlink:href">./svgDateis/<xsl:choose><xsl:when test="@cardColour = 'Spades'">Black</xsl:when><xsl:when test="@cardColour = 'Clubs'">Black</xsl:when><xsl:otherwise>Red</xsl:otherwise></xsl:choose><xsl:value-of select="@cardValue"/>.svg</xsl:attribute>
                    </image>
                    <g transform="translate(30,35) rotate(180) translate(-125, -180)" >
                        <image x="10" y="15" width="40" height="40" xlink:href=""  >
                            <xsl:attribute name="xlink:href">./svgDateis/<xsl:choose><xsl:when test="@cardColour = 'Spades'">Black</xsl:when><xsl:when test="@cardColour = 'Clubs'">Black</xsl:when><xsl:otherwise>Red</xsl:otherwise></xsl:choose><xsl:value-of select="@cardValue"/>.svg</xsl:attribute>
                        </image>
                    </g>
                </svg>
            </div>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>