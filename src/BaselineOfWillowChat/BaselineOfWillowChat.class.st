Class {
	#name : #BaselineOfWillowChat,
	#superclass : #BaselineOf,
	#category : #BaselineOfWillowChat
}

{ #category : #baselines }
BaselineOfWillowChat >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'WillowBootstrap'
				with: [ spec
						repository: 'github://ba-st/Willow-Bootstrap:v11/source';
						loads: 'Deployment' ].
			spec
				baseline: 'WillowSpinKit'
				with: [ spec repository: 'github://ba-st/Willow-SpinKit:v7/source'.
					spec loads: 'Deployment' ].
			spec
				package: 'DiamondSquare'
				with: [ spec
						repository: 'github://mattonem/Kata-DiamondSquareAlgo:master/src' ].
			spec 
				baseline: 'KataGameOfLife'
				with: [ spec
					repository: 'github://mattonem/Kata-GameOfLife:better-baseline/src'; 
					loads: 'core'].
			spec
				package: 'Sandbox';
				package: 'WillowShareModel';
				package: 'WillowChat';
				package: 'WillowDice';
				package: 'WillowDiamondSquare';
				yourself ]
]
