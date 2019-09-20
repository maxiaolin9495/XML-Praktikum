xquery version "3.0";

module namespace bj = "htmlforms/bj";

import module namespace state = "htmlforms/xquery/state" at "xquery/state.xqy";
import module namespace highscores = "htmlforms/xquery/highscores" at "xquery/highscores.xqy";

declare
	%rest:path("/htmlforms")
function bj:start() as element(Q{http://www.w3.org/1999/xhtml}html){
	let $value := (
		for $i in (1 to 10)
		return if (db:exists("htmlforms", fn:concat("games/", $i, ".xml"))) then 0 else $i
	)[. ne 0][1]
	
	return <html xmlns="http://www.w3.org/1999/xhtml" xmlns:xf="http://www.w3.org/2002/xforms" style="height:100%;
	font-family: 'Arial', 'Times New Roman'; overflow-wrap: break-word;">
		<head>
			<title>Southside Black Jack - Menu</title>
		</head>
		<body style="height: 100%; margin: 0%;">
			<div style="width: 100%; height: 10%;"/>
			<div style="width: 90%; height: 80%; margin:auto; background-color: darkred;">
				<div style="width: 100%; height: 10%;"/>
				<div style="width: 90%; height: 80%; margin: auto; background-color: darkgreen;">
					<div style="width: 100%; height: 10%;"/>
					<div style="width: 89%; font-size: 4vmin; text-align: center; margin: auto;
					background-color: darkred; color: darkgreen;">
						Welcome to Southside Black Jack
					</div>
					<div style="width: 100%; height: 10%;"/>
					{if ($value < 10) then (
						<div style="width: 89%; margin: 0% auto; overflow: auto;">
							<form action="htmlforms/new">
								<input type="hidden" name="game" value="{$value}" style="width: 99.5%;
								background-color: darkred; color: darkgreen; text-align: center; font-size: 3vmin;"/>
								<input type="submit" value="New Game" style="width: 100%; margin: 2% auto 0% auto;
								background-color: darkred; float: left; color: darkgreen; font-size: 3vmin;"
								onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
								onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'"/>
							</form>
						</div>
					) else ()}
					{if ($value > 1) then (
						<button onclick="window.location.href='htmlforms/loadScreen'" type="button" style="width: 89%;
						margin: 2% auto 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Load Game
						</button>
					) else ()}
					{if ($value > 1) then (
						<button onclick="window.location.href='htmlforms/deleteScreen'" type="button" style="width: 89%;
						margin: 2% auto 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Delete Game
						</button>
					) else ()}
					{if (db:exists("htmlforms", "highscores.xml")) then (
						<button onclick="window.location.href='htmlforms/highscores'" type="button" style="width: 89%;
						margin: 2% auto 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Show Highscores
						</button>
					) else ()}
				</div>
			</div>
		</body>
	</html>
};

declare
	%updating
	%rest:path("/htmlforms/new")
	%rest:query-param("game", "{$game}")
function bj:newGame($game as xs:string){
	let $state := state:newState($game)
		
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/newMenu?game=", $game)))
};

declare
	%rest:path("/htmlforms/newMenu")
	%rest:query-param("game", "{$game}")
function bj:newGameMenu($game as xs:string) as element(Q{http://www.w3.org/1999/xhtml}html){
	let $state := db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state
	let $count := count($state/player)
	
	return <html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;
	font-family: 'Arial', 'Times New Roman'; overflow-wrap: break-word;">
		<head>
			<title>Southside Black Jack - New Game</title>
		</head>
		<body style="height: 100%; margin: 0%;">
			<div style="width: 100%; height: 10%;"/>
			<div style="width: 90%; height: 80%; margin:auto; background-color: darkred;">
				<div style="width: 100%; height: 10%;"/>
				<div style="width: 90%; height: 80%; margin: auto; background-color: darkgreen;">
					<div style="width: 100%; height: 10%;"/>
					<div style="width: 89%; font-size: 4vmin; text-align: center; margin: auto;
					background-color: darkred; color: darkgreen;">
						New game with {$count} players
					</div>
					{if ($count < 7) then (
						<div style="width: 100%; height: 10%;"/>
					) else ()}
					{if ($count < 7) then (
						<div style="width: 89%; margin: 0% auto; overflow: auto;">
							<form action="add">
								<input type="hidden" name="game" value="{$game}"/>
								<input type="text" name="name" value="Player{$count+1}" style="width: 99.5%;
								background-color: darkred; color: darkgreen; text-align: center; font-size: 3vmin;"/>
								<input type="submit" value="Add Player" style="width: 100%; margin: 2% auto 0% auto;
								background-color: darkred; float: left; color: darkgreen; font-size: 3vmin;"
								onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
								onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'"/>
							</form>
						</div>
					) else ()}
	
					{if ($count > 0) then (
						<div style="width: 100%; height: 10%;"/>
					) else ()}
					{if ($count > 0) then (
						<button onclick="window.location.href='load?game={$game}';" type="button" style="width: 89%;
						margin: 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Start Game
						</button>
					) else ()}
				</div>
			</div>
		</body>
	</html>
};

declare
	%rest:path("/htmlforms/loadScreen")
function bj:loadScreen() as element(Q{http://www.w3.org/1999/xhtml}html){
	let $games := for $game in db:list("htmlforms", "games") order by $game return $game
	
	return <html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;
	font-family: 'Arial', 'Times New Roman'; overflow-wrap: break-word;">
		<head>
			<title>Southside Black Jack - Loading Screen</title>
		</head>
		<body style="height: 100%; margin: 0%;">
			<div style="width: 100%; height: 10%;"/>
			<div style="width: 90%; height: 80%; margin:auto; background-color: darkred;">
				<div style="width: 100%; height: 10%;"/>
				<div style="width: 90%; height: 80%; margin: auto; background-color: darkgreen;">
					<div style="width: 100%; height: 25%;"/>
					<div style="width: 89%; height: 50%; margin: auto; font-size: 4vmin; text-align: center;
					background-color: darkred; color: darkgreen;">
						<div style="width: 100%; height: 10%;"/>
						<div style="width: 89%; font-size: 4vmin; text-align: center; margin: 0% auto 2% auto;
						background-color: darkred; color: darkgreen;">
							Loading Screen
						</div>
						<div style="width: 89%; margin: 0% auto 2% auto; overflow: auto;">
							<form action="load">
								<div style="overflow: auto">
									{for $game in $games
									let $name := fn:substring($game, 7, 1)
								
									return if ($name ne ".") then (
										<div style="float: left; font-size: 3vmin;">
											Game {$name}<input type="radio" name="game" value="{$name}" style=""/>
										</div>
									) else ()}
								</div>
								<input type="submit" value="Load Game" style="width: 100%; margin: 2% auto 0% auto;
								background-color: darkred; float: left; color: darkgreen; font-size: 3vmin;"
								onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
								onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'"/>
							</form>
						</div>
						<button onclick="window.location.href='../htmlforms';" type="button" style="width: 89%;
						margin: 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Return
						</button>
					</div>
				</div>
			</div>
		</body>
	</html>
};

declare
	%rest:path("/htmlforms/deleteScreen")
function bj:deleteScreen() as element(Q{http://www.w3.org/1999/xhtml}html){
	let $games := for $game in db:list("htmlforms", "games") order by $game return $game
	
	return <html xmlns="http://www.w3.org/1999/xhtml" style="height:100%;
	font-family: 'Arial', 'Times New Roman'; overflow-wrap: break-word;">
		<head>
			<title>Southside Black Jack - Delete Screen</title>
		</head>
		<body style="height: 100%; margin: 0%;">
			<div style="width: 100%; height: 10%;"/>
			<div style="width: 90%; height: 80%; margin:auto; background-color: darkred;">
				<div style="width: 100%; height: 10%;"/>
				<div style="width: 90%; height: 80%; margin: auto; background-color: darkgreen;">
					<div style="width: 100%; height: 25%;"/>
					<div style="width: 89%; height: 50%; margin: auto; font-size: 4vmin; text-align: center;
					background-color: darkred; color: darkgreen;">
						<div style="width: 100%; height: 10%;"/>
						<div style="width: 89%; font-size: 4vmin; text-align: center; margin: 0% auto 2% auto;
						background-color: darkred; color: darkgreen;">
							Delete Screen
						</div>
						<div style="width: 89%; margin: 0% auto 2% auto; overflow: auto;">
							<form action="delete">
								<div style="overflow: auto">
									{for $game in $games
									let $name := fn:substring($game, 7, 1)
								
									return if ($name ne ".") then (
										<div style="float: left; font-size: 3vmin;">
											Game {$name}<input type="radio" name="game" value="{$name}" style=""/>
										</div>
									) else ()}
								</div>
								<input type="submit" value="Delete Game" style="width: 100%; margin: 2% auto 0% auto;
								background-color: darkred; float: left; color: darkgreen; font-size: 3vmin;"
								onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
								onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'"/>
							</form>
						</div>
						<button onclick="window.location.href='../htmlforms';" type="button" style="width: 89%;
						margin: 0% auto; display: block; background-color: darkred; color: darkgreen; font-size: 3vmin;"
						onmouseover="this.style.backgroundColor='darkgreen'; this.style.color='darkred'"
						onmouseout="this.style.backgroundColor='darkred'; this.style.color='darkgreen'">
							Return
						</button>
					</div>
				</div>
			</div>
		</body>
	</html>
};

declare
	%updating
	%rest:path("/htmlforms/add")
	%rest:query-param("game", "{$game}")
	%rest:query-param("name", "{$name}")
function bj:addPlayer ($game as xs:string, $name as xs:string){
	let $state := state:join(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state, $name)
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/newMenu?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/init")
	%rest:query-param("game", "{$game}")
function bj:initiate ($game as xs:string){
	let $state := state:initiate(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
};

declare
	%rest:path("/htmlforms/load")
	%rest:query-param("game", "{$game}")
	%output:method("xml")
	%output:omit-xml-declaration("no")
	%output:doctype-system("../static/htmlforms/blackjack.dtd")
function bj:loadGame ($game as xs:string){
	document {
		processing-instruction xml-stylesheet {
			'type="text/xsl" href="../static/htmlforms/blackjack.xsl"'
		},
		db:open("htmlforms", fn:concat("games/", $game, ".xml"))/node()
	}
};

declare
	%updating
	%rest:path("/htmlforms/delete")
	%rest:query-param("game", "{$game}")
function bj:delete ($game as xs:string){
	db:delete("htmlforms", fn:concat("games/", $game, ".xml")),
	update:output(web:redirect("/htmlforms"))
};

declare
	%rest:path("/htmlforms/highscores")
	%output:method("xml")
	%output:omit-xml-declaration("no")
	%output:doctype-system("../static/htmlforms/highscores.dtd")
function bj:loadHighscores (){
	document {
		processing-instruction xml-stylesheet {
			'type="text/xsl" href="../static/htmlforms/highscores.xsl"'
		},
		db:open("htmlforms", "highscores.xml")/node()
	}
};

declare
	%updating
	%rest:path("/htmlforms/split")
	%rest:query-param("game", "{$game}")
function bj:split ($game as xs:string){
	let $state := state:split(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/start")
	%rest:query-param("game", "{$game}")
function bj:startTurn ($game as xs:string){
	let $state := state:start(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/bet")
	%rest:query-param("game", "{$game}")
	%rest:query-param("bet", "{$bet}")
function bj:bet ($game as xs:string, $bet as xs:string){
	if (fn:number($bet) = fn:number($bet)) then (
		let $state := state:bet(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state, $bet)
		
		return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
		update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
	) else (
		update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
	)
};

declare
	%updating
	%rest:path("/htmlforms/draw")
	%rest:query-param("game", "{$game}")
function bj:drawCard ($game as xs:string){
	let $state := state:drawCard(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/endTurn")
	%rest:query-param("game", "{$game}")
function bj:endTurn ($game as xs:string){
	let $state := state:endTurn(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return if ($state/@gameState eq "betted") then (
			db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
			update:output(web:redirect(fn:concat("/htmlforms/init?game=", $game)))
	) else (
		if ($state/@gameState eq "ended") then (
			db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
			update:output(web:redirect(fn:concat("/htmlforms/endGame?game=", $game)))
		) else (
			db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
			update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
		)
	)
};

declare
	%updating
	%rest:path("/htmlforms/endGame")
	%rest:query-param("game", "{$game}")
function bj:endGame($game as xs:string){
	let $state := state:endGame(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	
	return db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
	update:output(web:redirect(fn:concat("/htmlforms/updateHighscores?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/updateHighscores")
	%rest:query-param("game", "{$game}")
function bj:updateHighscores($game as xs:string){
	let $highscores := if (db:exists("htmlforms", "highscores.xml")) then (
		highscores:updateHighscores(
			db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state,
			db:open("htmlforms", "highscores.xml")/highscores
		)
	) else (
		highscores:updateHighscores(
			db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state,
			highscores:newHighscores()
		)
	)
	
	return db:replace("htmlforms", "highscores.xml", $highscores),
	update:output(web:redirect(fn:concat("/htmlforms/sortHighscores?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/sortHighscores")
	%rest:query-param("game", "{$game}")
function bj:sortHighscores($game as xs:string){
	let $highscores := highscores:sortHighscores(db:open("htmlforms", "highscores.xml")/highscores)
	
	return db:replace("htmlforms", "highscores.xml", $highscores),
	update:output(web:redirect(fn:concat("/htmlforms/clean?game=", $game)))
};

declare
	%updating
	%rest:path("/htmlforms/clean")
	%rest:query-param("game", "{$game}")
function bj:cleanTable ($game as xs:string){
	let $state := state:cleanTable(db:open("htmlforms", fn:concat("games/", $game, ".xml"))/state)
	let $activePlayerNumber := count($state/player[./@state ne "ended"])
	
	return if ($activePlayerNumber > 0) then (
		db:replace("htmlforms", fn:concat("games/", $game, ".xml"), $state),
		update:output(web:redirect(fn:concat("/htmlforms/load?game=", $game)))
	) else (
		update:output(web:redirect(fn:concat("/htmlforms/delete?game=", $game)))
	)
};