Class {
	#name : #FamixTestComposed1UnknownSourceLanguage,
	#superclass : #FamixTestComposed1SourceLanguage,
	#traits : 'FamixTSourceLanguage + FamixTUnknownSourceLanguage',
	#classTraits : 'FamixTSourceLanguage classTrait + FamixTUnknownSourceLanguage classTrait',
	#category : #'Famix-TestComposedSubmetamodel1-Entities-Entities'
}

{ #category : #meta }
FamixTestComposed1UnknownSourceLanguage class >> annotation [

	<MSEClass: #UnknownSourceLanguage super: #FamixTestComposed1SourceLanguage>
	<package: #'Famix-TestComposedSubmetamodel1-Entities'>
	<generated>
	^self
]