Class {
	#name : #FamixTestComposed2UnknownSourceLanguage,
	#superclass : #FamixTestComposed2SourceLanguage,
	#traits : 'FamixTSourceLanguage + FamixTUnknownSourceLanguage',
	#classTraits : 'FamixTSourceLanguage classTrait + FamixTUnknownSourceLanguage classTrait',
	#category : #'Famix-TestComposedSubmetamodel2-Entities-Entities'
}

{ #category : #meta }
FamixTestComposed2UnknownSourceLanguage class >> annotation [

	<MSEClass: #UnknownSourceLanguage super: #FamixTestComposed2SourceLanguage>
	<package: #'Famix-TestComposedSubmetamodel2-Entities'>
	<generated>
	^self
]