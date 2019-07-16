Trait {
	#name : #SandboxGoogleSetup,
	#category : #Sandbox
}

{ #category : #updating }
SandboxGoogleSetup >> renderGAnalyticsOn: html [
	html script
		attributeAt: 'async' put: true;
		url: 'https://www.googletagmanager.com/gtag/js?id=UA-108092024-3'.
	html script
		with:
			'window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag(''js'', new Date());

  gtag(''config'', ''UA-108092024-3'');'
]

{ #category : #updating }
SandboxGoogleSetup >> updateRoot: aRoot [
	super updateRoot: aRoot.
	aRoot script
		attributeAt: 'async' put: true;
		url: '//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js'.
	aRoot script
		with:
			'  (adsbygoogle = window.adsbygoogle || []).push({
    google_ad_client: "ca-pub-6554111086429445",
    enable_page_level_ads: true
  });'.
	self renderGAnalyticsOn: aRoot.
]
