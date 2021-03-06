"
A TOODependencyQueries defines a vocabulary to compute dependencies of object-oriented entities.

For more informations: https://moosequery.ferlicot.fr/
"
Trait {
	#name : #TOODependencyQueries,
	#traits : 'TDependencyQueries',
	#category : #'Moose-Query-Traits'
}

{ #category : #meta }
TOODependencyQueries classSide >> annotation [

	<FMClass: #TOODependencyQueries super: #Object>
	<package: #'Moose-Query'>
	<generated>
	^self
]

{ #category : #testing }
TOODependencyQueries >> hasIncomingTypeDeclaration [
	"This method could be more readable but it needs to be really performant"

	| selectors |
	1 to: (selectors := self childrenSelectors) size do: [ :index | 
		(self perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | ((coll at: i) hasIncomingTypeDeclarations) ifTrue: [ ^ true ]  ] ] ].
	 ^ self entityHasIncomingTypeDeclarations.
]

{ #category : #testing }
TOODependencyQueries >> hasOutgoingTypeDeclaration [
	"This method could be more readable but it needs to be really performant"

	| selectors |
	1 to: (selectors := self childrenSelectors) size do: [ :index | 
		(self perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | ((coll at: i) hasOutgoingTypeDeclarations) ifTrue: [ ^ true ]  ] ] ].
	 ^ self entityHasOutgoingTypeDeclarations.
]
