xquery version "3.0";

module namespace deck = "htmlforms/xquery/deck";

import module namespace card = "htmlforms/xquery/card" at "card.xqy";

declare function deck:newDeck() as element(deck){
	let $deck := deck:shuffleCards(
		<deck>
			{for $i in (1 to 6), $colour in ("Diamonds", "Clubs", "Spades", "Hearts"), $value in ("2","3","4","5","6","7","8","9","10","J","Q","K","A")
			 return card:newCard($value, $colour, fn:false())}
		</deck>
	)
	
	return $deck update deck:deleteFirstCard(.)
};

declare function deck:shuffleCards($deck as element(deck)) as element(deck){
	<deck>
		{for $card in $deck/card
		order by random:integer(count($deck/card))
		return $card}
	</deck>
};

declare
	%updating
function deck:deleteFirstCard($deck as element(deck)){
	delete node ($deck/card)[1]
};

declare function deck:getFirstCard($deck as element(deck)) as element (card){
	($deck/card)[1]
};