xquery version "3.0";

module namespace card = "htmlforms/xquery/card";

declare function card:newCard($value as xs:string, $colour as xs:string, $isHidden as xs:boolean) as element(card){
	<card cardColour="{$colour}" cardValue= "{$value}" isHidden="{$isHidden}"/>
};

declare function card:getValue($card as element(card)) as xs:integer{
	switch ($card/@cardValue)
	case "A" return 1
	case "K" return 10
	case "Q" return 10
	case "J" return 10
	default return xs:integer($card/@cardValue)
};

declare function card:getHidden($card as element(card)) as xs:boolean{
	$card/@isHidden
};