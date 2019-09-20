<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="state">
		<html style="height:100%; font-family: 'Arial', 'Times New Roman'; font-size: 2vmin; overflow-wrap: break-word;">
			<head>
				<title>Southpark Blackjack</title>
			</head>
			<body style="height:100%; margin: 0px;">
				<div style="width: 10%; height: 100%; float: left;">
					<div style="width: 98.572%; margin-left: 1.428%; font-size: 4vmin;">Menu</div>
					<button onclick="location.href='../htmlforms';" type="button" style="width: 80%;
						margin: 0% 10% 0% 10%; background-color: black; color: white;"
						onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
						onmouseout="this.style.backgroundColor='black'; this.style.color='white'">
						Return!
					</button>
				</div>
				<div style="width: 80%; height: 100%; float: left; background-image:
					url(../static/htmlforms/svgs/playTable.svg); background-size: 100% 100%;">
					<xsl:apply-templates/>
				</div>
				<div style="width: 10%; height: 100%; float: left;">
					<div style="width: 98.572%; margin-left: 1.428%; font-size: 4vmin;">Actions</div>
					<!-- START OF BUTTON SECTION -->
					<xsl:variable name="game" select="./@name"/>
					<xsl:variable name="ifGameNew" select="./@gameState = 'new'"/>
					<xsl:variable name="ifGameStarted" select="./@gameState = 'started'"/>
					
					<xsl:choose>
						<xsl:when test="./@currentPlayer = 'Dealer'">
							<xsl:choose>
								<xsl:when test="$ifGameNew">
									<button onclick="location.href='endTurn?game={$game}';" type="button" style="width: 80%;
										margin: 0% 10% 5% 10%; background-color: black; color: white;"
										onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
										onmouseout="this.style.backgroundColor='black'; this.style.color='white'">
										End betting!
									</button>
								</xsl:when>
								<xsl:when test="$ifGameStarted">
									<xsl:choose>
										<xsl:when test="17 > ./dealer/@handValue">
											<!-- if the dealer's handValue is less than 17, he must pick more cards -->
											<button onclick="location.href='draw?game={$game}';" type="button"
												style="width: 80%; margin: 0% 10% 0% 10%; background-color: black;
												color: white;" onmouseover="this.style.backgroundColor='white';
												this.style.color='black'" onmouseout="this.style.backgroundColor='black';
												this.style.color='white'">
												Draw card!
											</button>
										</xsl:when>
										<xsl:otherwise>
											<button onclick="location.href='endTurn?game={$game}';" type="button" style="width: 80%;
												margin: 0% 10% 5% 10%; background-color: black; color: white;"
												onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
												onmouseout="this.style.backgroundColor='black'; this.style.color='white'">
												End game!
											</button>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>	
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="playing" select="./@currentPlayer"/>
							<xsl:variable name="ifPlayerEnded" select="./player[@id = $playing]/@state = 'ended'"/>
							
							<xsl:choose>
								<!-- inactive players rounds are ended directly -->
								<xsl:when test="$ifPlayerEnded">
									<button onclick="location.href='endTurn?game={$game}';" type="button" style="width: 80%;
										margin: 0% 10% 0% 10%; background-color: black; color: white;"
										onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
										onmouseout="this.style.backgroundColor='black'; this.style.color='white'">
										End turn!
									</button>
								</xsl:when>
								<xsl:otherwise>									
									<xsl:choose>
										<!-- in the first round, only bets are possible actions -->
										<xsl:when test="$ifGameNew">
											<xsl:variable name="maxBet" select="./player/@deposit"/>
											
											<div style="width: 80%; margin: 0% auto; overflow: auto;">
												<form action="bet">
													<input type="hidden" name="game" value="{$game}"/>
													<input type="text" name="bet" value="10" min="1" max="maxBet"
														style="width: 96.14%; background-color: black; color: white;
														text-align: center;"/>
													<input type="submit" value="Bet!" style="width: 100%;
														margin: 2% auto 5% auto; float: left; background-color: black;
														color: white;"
														onmouseover="this.style.backgroundColor='white';
														this.style.color='black'"
														onmouseout="this.style.backgroundColor='black';
														this.style.color='white'"/>
												</form>
											</div>
											<button onclick="location.href='endTurn?game={$game}';" type="button" style="width: 80%;
												margin: 0% 10% 0% 10%; background-color: black; color: white;"
												onmouseover="this.style.backgroundColor='white'; this.style.color='black'"
												onmouseout="this.style.backgroundColor='black';	this.style.color='white'">
												End turn!
											</button>
										</xsl:when>
										<!-- in the second round, the remaining actions can be performed -->
										<xsl:when test="$ifGameStarted">
											<xsl:variable name="ifPlayerNew" select="./player[@id = $playing]/@state = 'new'"/>
											<xsl:variable name="ifPlayerStarted"
												select="./player[@id = $playing]/@state = 'started'"/>
											
											<xsl:choose>
												<!-- each active player is allowed to perform the following actions
													before he starts his round -->
												<xsl:when test="$ifPlayerNew">
													<xsl:variable name="cardValue1"
														select="./player[@id = $playing]/hand[1]/card[1]/@cardValue"/>
													<xsl:variable name="cardValue2"
														select="./player[@id = $playing]/hand[1]/card[2]/@cardValue"/>
													<xsl:variable name="canSplit" select="$cardValue1 = $cardValue2"/>
													
													<xsl:choose>
														<xsl:when test="$canSplit">
															<button onclick="location.href='split?game={$game}';" type="button"
																style="width: 80%; margin: 0% 10% 5% 10%;
																background-color: black; color: white;"
																onmouseover="this.style.backgroundColor='white';
																this.style.color='black'"
																onmouseout="this.style.backgroundColor='black';
																this.style.color='white'">
																Split!
															</button>
														</xsl:when>
													</xsl:choose>
													<button onclick="location.href='start?game={$game}';" type="button"
														style="width: 80%; margin: 0% 10%; background-color: black;
														color: white;" onmouseover="this.style.backgroundColor='white';
														this.style.color='black'"
														onmouseout="this.style.backgroundColor='black';
														this.style.color='white'">
														Start round!
													</button>
												</xsl:when>
												<xsl:when test="$ifPlayerStarted">
													<xsl:variable name="handId"
														select="./player[@id = $playing]/@currentHand"/>
													<xsl:variable name="canPick"
														select="21 > ./player[@id = $playing]/hand[@id = $handId]/@handValue"/>
													<xsl:choose>
														<xsl:when test="$canPick">
															<button onclick="location.href='draw?game={$game}';"
																type="button" style="width: 80%; margin: 0% 10% 5% 10%;
																background-color: black; color: white;"
																onmouseover="this.style.backgroundColor='white';
																this.style.color='black'"
																onmouseout="this.style.backgroundColor='black';
																this.style.color='white'">
																Pick Card!
															</button>
														</xsl:when>
													</xsl:choose>
													<button onclick="location.href='endTurn?game={$game}';" type="button"
														style="width: 80%; margin: 0% 10% 0% 10%; background-color: black;
														color: white;" onmouseover="this.style.backgroundColor='white';
														this.style.color='black'" onmouseout="this.style.backgroundColor='black';
														this.style.color='white'">
														End turn!
													</button>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<!-- END OF BUTTON SECTION -->
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="deck">
		<div style="width: 28.56%; height: 28%; float: left;">
			<div style="width: 99%; margin-left: 0.5%; font-size: 4vmin;">Deck</div>
			<div style="width: 99%; margin-left: 0.5%;">
				<div style="width: 12.5%; float: left;">
					<svg version="1.1" viewBox="0 0 48 66" width="100%" xmlns="http://www.w3.org/2000/svg"
						 xmlns:xlink="http://www.w3.org/1999/xlink">
						<image height="66" width="48" x="0" xlink:href="../static/htmlforms/svgs/Backside.png" y="0"/>
					</svg>
				</div>
				<div style="width: 12.5%; margin-left: -9%; float: left;">
					<svg version="1.1" viewBox="0 0 48 66" width="100%" xmlns="http://www.w3.org/2000/svg"
						 xmlns:xlink="http://www.w3.org/1999/xlink">
						<image height="66" width="48" x="0" xlink:href="../static/htmlforms/svgs/Backside.png" y="0"/>
					</svg>
				</div>
				<div style="width: 12.5%; margin-left: -9%; float: left;">
					<svg version="1.1" viewBox="0 0 48 66" width="100%" xmlns="http://www.w3.org/2000/svg"
						 xmlns:xlink="http://www.w3.org/1999/xlink">
						<image height="66" width="48" x="0" xlink:href="../static/htmlforms/svgs/Backside.png" y="0"/>
					</svg>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="dealer">
		<div style="width: 71.44%; height: 28%; float: left;">
			<div style="width: 99.8%; margin-left: 0.2%; font-size: 4vmin;">Dealer</div>
			<div style="width: 99.8%; margin-left: 0.2%;">
				<xsl:call-template name="DealerCard"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="player">
		<xsl:choose>
			<xsl:when test="@id = ../@currentPlayer">
				<!-- current player -->
				<div style="width: 12.285%; height: 72%; padding: 0% 1.9% 0% 0.1%; float: left;
					background-color: rgba(0, 0, 0, 0.75); color: red;">
					<div style="width: 99%; height: 3.5%; margin-left: 1%;">
						<xsl:value-of select="@name"/>
					</div>
					<div style="width: 99%; height: 3.5%; margin-left: 1%;">
						Deposit: <xsl:value-of select="@deposit"/>
					</div>
					<xsl:for-each select="hand">
						<div style="width: 100%; height: 30%; margin-bottom: 1%;">
							<div style="width: 100%; margin-top: 1%; text-align: center; font-size: 3vmin;">
								Box: <xsl:value-of select="@box"/>
							</div>
							<div style="width: 100%; margin-top: 1%;">
								<xsl:call-template name="PlayerCard"/>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- every other player -->
				<div style="width: 12.285%; height: 72%; padding: 0% 1.9% 0% 0.1%; float: left;
					background-color: rgba(0, 0, 0, 0.5); color: darkred;">
					<div style="width: 99%; height: 3.5%; margin-left: 1%;">
						<xsl:value-of select="@name"/>
					</div>
					<div style="width: 99%; height: 3.5%; margin-left: 1%;">
						Deposit: <xsl:value-of select="@deposit"/>
					</div>
					<xsl:for-each select="hand">
						<div style="width: 100%; height: 30%; margin-bottom: 1%;">
							<div style="width: 100%; margin-top: 1%; text-align: center; font-size: 3vmin;">
								Box: <xsl:value-of select="@box"/>
							</div>
							<div style="width: 100%; margin-top: 1%;">
								<xsl:call-template name="PlayerCard"/>
							</div>
						</div>
					</xsl:for-each>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="DealerCard">
		<xsl:for-each select="card">
			<xsl:choose>
				<xsl:when test="@isHidden = 'true'">
					<!-- hidden cards -->
					<div style="width: 5.164%; margin-right: -3.718%; float: left;">
						<svg version="1.1" viewBox="0 0 160 220" width="100%"
							 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
							<image height="220" width="160" x="0" xlink:href="../static/htmlforms/svgs/Backside.png" y="0"/>
						</svg>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<!-- visible cards -->
					<div style="width: 5.164%; margin-right: -3.718%; float: left;">
						<svg version="1.1" viewBox="0 0 160 220" width="100%"
							 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
							<image height="220" width="160" x="0" xlink:href="../static/htmlforms/svgs/cardBackground.svg"
								   y="0"/>
							<image height="40" width="40" x="60" xlink:href="" y="90">
								<xsl:attribute name="xlink:href">
									../static/htmlforms/svgs/<xsl:value-of select="@cardColour"/>.svg
								</xsl:attribute>
							</image>
							<image height="40" width="40" x="10" xlink:href="" y="15">
								<xsl:attribute name="xlink:href">
									../static/htmlforms/svgs/<xsl:choose>
									<xsl:when test="@cardColour = 'Spades'">Black</xsl:when>
									<xsl:when test="@cardColour = 'Clubs'">Black</xsl:when>
									<xsl:otherwise>Red</xsl:otherwise>
								</xsl:choose><xsl:value-of select="@cardValue"/>.svg
								</xsl:attribute>
							</image>
							<g transform="translate(30,35) rotate(180) translate(-125, -180)">
								<image height="40" width="40" x="10" xlink:href="" y="15">
									<xsl:attribute name="xlink:href">
										../static/htmlforms/svgs/<xsl:choose>
										<xsl:when test="@cardColour = 'Spades'">Black</xsl:when>
										<xsl:when test="@cardColour = 'Clubs'">Black</xsl:when>
										<xsl:otherwise>Red</xsl:otherwise>
									</xsl:choose><xsl:value-of select="@cardValue"/>.svg
									</xsl:attribute>
								</image>
							</g>
						</svg>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="PlayerCard">
		<xsl:for-each select="card">
			<xsl:choose>
				<xsl:when test="@isHidden = 'true'">
					<!-- hidden cards; not currently existing ingame but maybe useful for later variants -->
					<div style="width: 30%; margin-right: -21.6%; float: left;">
						<svg version="1.1" viewBox="0 0 160 220" width="100%"
							 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
							<image height="220" width="160" x="0" xlink:href="../static/htmlforms/svgs/Backside.png" y="0"/>
						</svg>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<!-- visible cards -->
					<div style="width: 30%; margin-right: -21.6%; float: left;">
						<svg version="1.1" viewBox="0 0 160 220" width="100%"
							 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
							<image height="220" width="160" x="0" xlink:href="../static/htmlforms/svgs/cardBackground.svg" y="0"/>
							<image height="40" width="40" x="60" xlink:href="" y="90">
								<xsl:attribute name="xlink:href">
									../static/htmlforms/svgs/<xsl:value-of select="@cardColour"/>.svg
								</xsl:attribute>
							</image>
							<image height="40" width="40" x="10" xlink:href="" y="15">
								<xsl:attribute name="xlink:href">
									../static/htmlforms/svgs/<xsl:choose>
									<xsl:when test="@cardColour = 'Spades'">Black</xsl:when>
									<xsl:when test="@cardColour = 'Clubs'">Black</xsl:when>
									<xsl:otherwise>Red</xsl:otherwise>
								</xsl:choose><xsl:value-of select="@cardValue"/>.svg
								</xsl:attribute>
							</image>
							<g transform="translate(30,35) rotate(180) translate(-125, -180)">
								<image height="40" width="40" x="10" xlink:href="" y="15">
									<xsl:attribute name="xlink:href">
										../static/htmlforms/svgs/<xsl:choose>
										<xsl:when test="@cardColour = 'Spades'">Black</xsl:when>
										<xsl:when test="@cardColour = 'Clubs'">Black</xsl:when>
										<xsl:otherwise>Red</xsl:otherwise>
									</xsl:choose><xsl:value-of select="@cardValue"/>.svg
									</xsl:attribute>
								</image>
							</g>
						</svg>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
