xquery version "3.0";

module namespace dealer = "htmlforms/xquery/dealer";

import module namespace card = "htmlforms/xquery/card" at "card.xqy";

declare function dealer:newDealer() as element(dealer){
	<dealer id="Dealer" handValue="0">
	</dealer>
};

declare function dealer:calculateHandValueHelp($dealer as element(dealer)) as xs:boolean{
	let $counts := count($dealer/card[@cardValue = "A"])
	
	return if ($counts >= 1 ) then fn:true() else fn:false()
};

declare
	%updating
function dealer:calculateHandValue($dealer as element(dealer)){
    let $cards := $dealer/card
    let $cardValuesPos1 := (for $card in $cards return card:getValue($card))
    let $pos1 := sum($cardValuesPos1)
    
    return if (dealer:calculateHandValueHelp($dealer) and $pos1 <= 11) then (
    	replace value of node $dealer/@handValue with $pos1 + 10
    ) else (
    	replace value of node $dealer/@handValue with $pos1
    )
};

declare
	%updating
function dealer:drawCard ($dealer as element(dealer), $card as element(card)){
	insert node $card as last into $dealer
};

declare
	%updating
function dealer:endTurn ($dealer as element(dealer)){
	replace value of node $dealer/../@currentPlayer with "PER-1"
};