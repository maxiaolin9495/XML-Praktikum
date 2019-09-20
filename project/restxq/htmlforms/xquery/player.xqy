xquery version "3.0";

module namespace player = "htmlforms/xquery/player";

import module namespace hand = "htmlforms/xquery/hand" at "hand.xqy";

declare function player:newPlayer($id as xs:string, $name as xs:string) as element(player){
	let $handId := fn:concat($id, -1)
	return <player id="{$id}" currentHand="{$handId}" name="{$name}" state="new" deposit="200">
		{hand:newHand($handId)}
	</player>
};

declare
	%updating
function player:calculateHandValues($player as element(player)){
	for $hand in $player/hand
	return hand:calculateHandValue($hand)
};

declare
	%updating
function player:split($player as element(player)){
	hand:split($player/hand[@id eq ../@currentHand])
};

declare
	%updating
function player:bet($player as element(player), $bet as xs:string){
	hand:bet($player/hand[@id eq ../@currentHand], xs:integer($bet))
};

declare
	%updating
function player:drawCard($player as element(player), $card as element(card)){
	insert node $card as last into $player/hand[@id eq ../@currentHand]
};

(: This functions parameter cannot be of type element(player)
   as it is an updating function
   and not only an element(player) but an elment(dealer) is updated :)
declare
	%updating
function player:endTurn($state as element(state)){
	let $previousPlayerId := $state/@currentPlayer
	let $previousPlayer := $state/player[@id eq $previousPlayerId]
	let $previousHandId := $previousPlayer/@currentHand
	let $handAmount := count($previousPlayer/hand)
	
	return if ($handAmount > 1 and fn:substring(xs:string($previousHandId), 7, 1) eq "1") then (
		let $currentHandId := fn:concat($previousPlayerId, "-2")
	
		return replace value of node $previousHandId with $currentHandId
	) else (
		let $currentHandId := fn:concat($previousPlayerId, "-1")
		
		return if ($previousPlayerId eq $state/player[last()]/@id) then (
			let $currentPlayerId := "Dealer"
			
			return if ($state/@gameState eq "started") then (
				replace value of node $state/dealer/card[2]/@isHidden with fn:false(),
				replace value of node $previousHandId with $currentHandId,
				replace value of node $previousPlayerId with $currentPlayerId
			) else (
				replace value of node $previousHandId with $currentHandId,
				replace value of node $previousPlayerId with $currentPlayerId
			)
		) else (
			let $currentPlayerId := fn:concat(
				"PER-",
				xs:string(xs:integer(fn:substring(xs:string($previousPlayerId), 5, 1)) + 1)
			)
			
			return (replace value of node $previousHandId with $currentHandId,
			replace value of node $previousPlayerId with $currentPlayerId)
		)
	)
};

declare
	%updating
function player:endGame($player as element(player)){
	let $dealerHandValue := $player/../dealer/@handValue
	let $hands := $player/hand[@handValue <= 21]
	let $oldDeposit := $player/@deposit
		
	return if ($dealerHandValue > 21) then (
		let $winnerHands := $hands
		let $addition := 2 * fn:sum(for $hand in $winnerHands return xs:integer($hand/box))
		let $newDeposit := xs:integer($oldDeposit) + $addition
			
		return replace value of node $oldDeposit with $newDeposit
	) else (
		if ($dealerHandValue < 21) then (
			let $winnerHands := $hands[@handValue > $dealerHandValue]
			let $tieHands := $hands[@handValue = $dealerHandValue]
			let $addition := 2 * fn:sum(
				for $hand in $winnerHands
				return xs:integer($hand/box)
			) + fn:sum(
				for $hand in $tieHands
				return xs:integer($hand/box)
			)
			let $newDeposit := xs:integer($oldDeposit) + $addition
			
			return replace value of node $oldDeposit with $newDeposit
		) else (
			let $winnerHands := $hands[@handValue = 21 and count(./card) = 2]
			let $tieHands := $hands[@handValue = 21 and count(./card) > 2]
			let $addition := 2 * fn:sum(
				for $hand in $winnerHands
				return xs:integer($hand/box)
			) + fn:sum(
				for $hand in $tieHands
				return xs:integer($hand/box)
			)
			let $newDeposit := xs:integer($oldDeposit) + $addition
			
			return replace value of node $oldDeposit with $newDeposit
		)
	)
};

declare
	%updating
function player:resetHands($player as element(player)){
	delete node $player/hand,
	insert node hand:newHand(fn:concat($player/@id, -1)) as last into $player
};
