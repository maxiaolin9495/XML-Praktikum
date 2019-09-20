fxquery version "3.0";

module namespace state = "htmlforms/xquery/state";

import module namespace deck = "htmlforms/xquery/deck" at "deck.xqy";
import module namespace dealer = "htmlforms/xquery/dealer" at "dealer.xqy";
import module namespace player = "htmlforms/xquery/player" at "player.xqy";

declare function state:newState($game as xs:string) as element(state){
	<state currentPlayer="PER-1" name="{$game}" gameState="new">
		{deck:newDeck()}
		{dealer:newDealer()}
	</state>
};

declare function state:join($state as element(state), $playerName as xs:string) as element(state){
	let $playerNum := count($state/player)
	let $id := $playerNum + 1
	return if($playerNum >= 7) then $state
	else $state update insert node player:newPlayer(fn:concat("PER-", $id), $playerName) as last into .
};

declare function state:initiate($state as element(state)) as element(state){
	if ($state/@currentPlayer eq "Dealer") then (
		state:endTurn(state:drawCard(state:drawCard($state)))
	) else (
		if ($state/player[@id eq ../@currentPlayer]/@state eq "ended") then (
			state:initiate(state:endTurn($state))
		) else (
			state:initiate(state:endTurn(state:drawCard(state:drawCard($state))))
		)
	)
};

declare function state:split($state as element(state)) as element(state){
	$state update {
		player:split(./player[@id eq ../@currentPlayer])
	 } update {
	 	player:calculateHandValues(./player[@id eq ../@currentPlayer])
	 }
};

declare function state:start($state as element(state)) as element(state){
	$state update replace value of node ./player[@id eq ../@currentPlayer]/@state with "started"
};

declare function state:bet($state as element(state), $bet as xs:string) as element(state){
	if (xs:integer($state/player[@id eq ../@currentPlayer]/@deposit) < xs:integer($bet)) then (
		$state
	) else (
		$state update player:bet (./player[@id eq ../@currentPlayer], $bet)
	)
};

declare function state:drawCard($state as element(state)) as element(state){
	if ($state/@currentPlayer eq "Dealer") then (
		$state update {
			dealer:drawCard(./dealer, deck:getFirstCard(./deck))
		} update {
			deck:deleteFirstCard(./deck)
		} update {
			dealer:calculateHandValue(./dealer)
		}
	) else (
		$state update {
			player:drawCard(./player[@id eq ../@currentPlayer], deck:getFirstCard(./deck))
		} update {
			deck:deleteFirstCard(./deck)
		} update {
			player:calculateHandValues(./player[@id eq ../@currentPlayer])
		}
	)
};

declare function state:endTurn($state as element(state)) as element(state){
	if ($state/@currentPlayer eq "Dealer") then (
		if ($state/@gameState eq "new") then (
			(: Dealer endTurn for bet :)
			$state update {
				dealer:endTurn(./dealer)
			} update {
				replace value of node ./@gameState with "betted"
			}
		) else (
			if ($state/@gameState eq "betted") then (
				(: Dealer endTurn for initiate :)
				$state update {
					dealer:endTurn(./dealer)
				} update {
					replace value of node ./dealer/card[2]/@isHidden with fn:true()
				} update {
					replace value of node ./@gameState with "started"
				}
			) else (
				(: Normal dealer endTurn :)
				$state update {
					dealer:endTurn(./dealer)
				} update {
					replace value of node ./@gameState with "ended"
				}
			)
		)
	) else (
		(: Player endTurn :)
		$state update player:endTurn(.)
	)
};

declare function state:endGame($state as element(state)) as element(state){
	$state update for $player in ./player return player:endGame($player)
};

declare function state:cleanTable($state as element(state)) as element(state){
	$state update {
		replace value of node ./@gameState with "new"
	} update {
		replace value of node ./@currentPlayer with "PER-1"
	} update {
		for $player in ./player
		
		return if ($player/@deposit > 0) then (
			replace value of node $player/@state with "new"
		) else (
			replace value of node $player/@state with "ended"
		)
	} update {
		replace node ./deck with deck:newDeck()
	} update {
		delete node ./dealer/card
	} update {
		for $player in ./player return player:resetHands($player)
	}
};