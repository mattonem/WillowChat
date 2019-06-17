Class {
	#name : #WDiamondSquareFileLibrary,
	#superclass : #WAFileLibrary,
	#classVars : [
		'files'
	],
	#category : #WillowDiamondSquare
}

{ #category : #convenience }
WDiamondSquareFileLibrary class >> addBitmapAsPng: amodel TTL: duration [
	| key morph file |
	key :=self asSelector:  UUID new asString, '.png'.
	morph := amodel morph.
	file := ByteArray streamContents: [ :out | PNGReadWriter putForm: morph onStream: out ].
	files at: key put: file.
	[ duration wait.
	files removeKey: key ] fork.

	^ key
]

{ #category : #'class initialization' }
WDiamondSquareFileLibrary class >> initialize [
	files := Dictionary new.
]

{ #category : #accessing }
WDiamondSquareFileLibrary >> documentOf: aSelector [
	^ files at: aSelector
]

{ #category : #accessing }
WDiamondSquareFileLibrary >> fileSelectors [
	^ files keys
]

{ #category : #actions }
WDiamondSquareFileLibrary >> isFileSelector: aSymbol [
	^ files includesKey: aSymbol
]
