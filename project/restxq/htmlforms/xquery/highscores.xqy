xquery version "3.0";

module namespace highscores = "htmlforms/xquery/highscores";

import module namespace state = "htmlforms/xquery/state" at "state.xqy";

declare function highscores:newHighscores() as element(highscores){
	<highscores/>
};

declare function highscores:updateHighscores(
	$state as element(state),
	$highscores as element(highscores)
) as element(highscores){
	$highscores update for $player in $state/player
	let $playerscore := ./score[@name eq $player/@name]
	return if (count($playerscore) < 1) then (
		insert node
			<score name="{$player/@name}" value="{$player/@deposit}"/>
		as last into .
	) else (
		if ($playerscore/@value < $player/@deposit) then (
			replace value of node $playerscore/@value with $player/@deposit
		) else ()
	)
};

declare function highscores:sortHighscores($highscores as element(highscores)) as element(highscores){
	<highscores>
		{for $score in $highscores/score
		 order by $score/@value descending
		 return $score}
	</highscores>
};