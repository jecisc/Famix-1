Class {
	#name : #FamixTest2UnknownSourceLanguage,
	#superclass : #FamixTest2SourceLanguage,
	#traits : 'FamixTSourceLanguage + FamixTUnknownSourceLanguage',
	#classTraits : 'FamixTSourceLanguage classTrait + FamixTUnknownSourceLanguage classTrait',
	#category : #'Famix-Test2-Entities-Entities'
}

{ #category : #meta }
FamixTest2UnknownSourceLanguage class >> annotation [

	<MSEClass: #UnknownSourceLanguage super: #FamixTest2SourceLanguage>
	<package: #'Famix-Test2-Entities'>
	<generated>
	^self
]