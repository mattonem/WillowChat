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
				project: 'WillowBootstrap'
				with: [ spec
						repository: 'github://ba-st/Willow-Bootstrap:v11/source';
						loads: 'Deployment' ].
			spec
				package: 'WillowChat';
				yourself ]
]
