Class {
	#name : #WDiamondSquareApplication,
	#superclass : #WillowApplication,
	#instVars : [
		'content',
		'result',
		'map',
		'form',
		'bitmap',
		'editSubmitButton',
		'sizeInput'
	],
	#category : #WillowDiamondSquare
}

{ #category : #accessing }
WDiamondSquareApplication class >> applicationTitle [

	^ 'Willow DiamondSquare Algo'
]

{ #category : #accessing }
WDiamondSquareApplication class >> handlerName [
^ 'DiamondSquare'
]

{ #category : #accessing }
WDiamondSquareApplication >> componentSupplierForApplication [

	^ BootstrapComponentSupplier
		withBootstrapLibrary: (self deploymentMode libraryFor: Bootstrap3MetadataLibrary) withoutOptionalTheme
		selectLibrary: ((self deploymentMode libraryFor: BootstrapSelectLibrary) using: self language)
		datepickerLibrary: ((self deploymentMode libraryFor: BootstrapDatepickerLibrary) using: self language)
		typeaheadLibrary: (self deploymentMode libraryFor: BootstrapTypeaheadLibrary) new
]

{ #category : #accessing }
WDiamondSquareApplication >> computeMap [
	bitmap := (DiamondSquare newSize: self mapSize rand: Random new) map.
	self initializeMap 
]

{ #category : #accessing }
WDiamondSquareApplication >> contentView [

	^ content
]

{ #category : #accessing }
WDiamondSquareApplication >> initialize [ 
	super initialize.
	self initializeResult.
	self initializeContent.
	self initializeMap.
	self initializeForm.
	self initializeSizeInput.
	
	self initializeSubmitButton.
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeContent [
	^ content := IdentifiedWebView
		forDivNamed: 'root'
		containing: [ :canvas | 
			canvas heading: 'Diamond Square Generator'.
			canvas render: result ]
		applying: [ :div | div addClass bootstrap containerFluid ]
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeForm [
	form := IdentifiedWebView
		forFormNamed: 'form'
		containing: [ :canvas | 
			canvas label: 'Size: (must be between 1 and 8)'.
			canvas render: sizeInput.
			canvas render: editSubmitButton ]
		applying: [ :aForm | 
			aForm addClass bootstrap formGroup
				+ aForm addClass bootstrap containerFluid ]
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeMap [
	^ map := IdentifiedWebView
		forDivNamed: 'map'
		containing: [ :canvas |self renderMapOn: canvas]
		applying: [ :div | div addClass bootstrap containerFluid ]
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeResult [
	^ result := IdentifiedWebView
		forDivNamed: 'result'
		containing: [ :canvas | 
			canvas render: form.
			canvas render: map ]
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeSizeInput [
	^ sizeInput := (NumberFieldWebView
		applying: [ :field | 
			field addClass bootstrap formControl
				+ field addClass bootstrap textRight+ (field setPlaceholderTo: '1 | 2 | 3 | 4 | 5 | 6 | 7 | 8') ]
		transformingWith: NaturalNumberCodec new)
]

{ #category : #accessing }
WDiamondSquareApplication >> initializeSubmitButton [
	editSubmitButton := AsynchronicButtonWebView
		labeled: 'generate'
		applying: [ :theButton | theButton addClass bootstrap button ].
	editSubmitButton onTrigger
		transform: result into: SpinKitRotatingPlane new;
		serializeContainerForm;
		determineBehaviorByEvaluating: [ :response | 
			self computeMap.
			response onReturn render: result ]
]

{ #category : #accessing }
WDiamondSquareApplication >> jQueryLibrary [

	^(self deploymentMode libraryFor: JQuery3MetadataLibrary) default
]

{ #category : #accessing }
WDiamondSquareApplication >> mapSize [
	^ self possibleSize detect: [:e | e = ([sizeInput number] on: InstanceCreationFailed do: [5])] ifFound: [ :e| (2 ** e) + 1 ] ifNone: [ 33 ]
]

{ #category : #accessing }
WDiamondSquareApplication >> possibleSize [
	^ (1 to: 8 ) asArray 
]

{ #category : #accessing }
WDiamondSquareApplication >> renderMapOn: aCanvas [
	bitmap ifNil: [ ^ self ].
	aCanvas
		table: [ | size |
			size := bitmap size sqrt.
			1 to: size do: [ :i | 
				aCanvas tableRow
					with: [ 1 to: size do: [ :j | 
							aCanvas tableData
								style:
									'background-color: ' , (Color gray: (bitmap at: i @ j)) asHTMLColor
										, ';';
								with: [ aCanvas div style: 'min-width: 1px;min-height: 1px;' ] ] ] ] ]
]

{ #category : #accessing }
WDiamondSquareApplication >> requiredLibraries [

	" Libraries added here are not considered until the server is restarted.
	  Including a library with a favicon.ico will automatically use it.	"
	^ {	SpinKitMetadataLibrary default}
]
