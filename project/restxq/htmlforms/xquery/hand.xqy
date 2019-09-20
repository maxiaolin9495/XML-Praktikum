xquery version "3.0";

module namespace hand = "htmlforms/xquery/hand";

import module namespace card = "htmlforms/xquery/card" at "card.xqy";

declare function hand:newHand($id as xs:string) as element(hand){
	<hand id="{$id}" box="0" handValue="0"/>
};

declare function hand:newHandBox($id as xs:string, $box as xs:string) as element(hand){
	<hand id="{$id}" box="{$box}" handValue="0"/>
};

declare function hand:calculateHandValueHelp($hand as element(hand)) as xs:boolean{
	let $counts := count($hand/card[@cardValue = "A"])
	
	return if ($counts >= 1 ) then fn:true() else fn:false()
};

declare
	%updating
function hand:calculateHandValue($hand as element(hand)){
    let $cards := $hand/card
    let $cardValuesPos1 := for $card in $cards return card:getValue($card)
    let $pos1 := sum($cardValuesPos1)
    
    return if (hand:calculateHandValueHelp($hand) and $pos1 <= 11) then (
    	replace value of node $hand/@handValue with $pos1 + 10
    ) else (
    	replace value of node $hand/@handValue with $pos1
    )
};

declare
	%updating
function hand:split($hand as element(hand)){
	let $oldDeposit := $hand/../@deposit
	let $newDeposit:= xs:string(xs:integer($oldDeposit) - xs:integer($hand/@box))
	let $hand2 := hand:newHandBox(fn:concat($hand/../@id, "-2"), $hand/@box) update insert node $hand/card[2] into .
	
	return (insert node $hand2 into $hand/..,
	delete node $hand/card[2],
	replace value of node $oldDeposit with $newDeposit)
};

declare
	%updating
function hand:bet($hand as element(hand), $bet as xs:integer){
	let $oldDeposit := $hand/../@deposit
	let $newDeposit := xs:string(max(((xs:integer($oldDeposit) - $bet), 0)))
	let $oldBet := $hand/@box
	let $newBet := xs:string(xs:integer($oldBet) + min(($bet, xs:integer($oldDeposit))))
	
	return (replace value of node $oldDeposit with $newDeposit,
	replace value of node $oldBet with $newBet)
};