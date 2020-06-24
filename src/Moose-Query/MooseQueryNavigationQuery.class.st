"
Description
-------------------

I am an object reponsible for the computation of a query. I am here to hide the implementations of queries to the entities. 

For more informations: https://moosequery.ferlicot.fr/

Examples
-------------------
	
	(MooseQueryCalculator direction: #in) query: FAMIXInvocation for: aMethod.
	
	(MooseQueryCalculator strategy: MooseQueryOutgoingDirectionStrategy) queryAllLocalFor: aMethod.
	
	(MooseQueryCalculator strategy: MooseQueryIncomingDirectionStrategy) query: FAMIXInvocation for: aMethod.
 
Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	strategy:		<aMooseQueryDirectionStrategy> 		A strategy responsible of the behavior depending on the direction of the association


"
Class {
	#name : #MooseQueryNavigationQuery,
	#superclass : #MooseQueryAbstractQuery,
	#instVars : [
		'directionStrategy',
		'resultKindStrategy',
		'associationSelectionStrategy',
		'shouldCollectChildrenDependencies'
	],
	#category : #'Moose-Query-Navigating'
}

{ #category : #'instance creation' }
MooseQueryNavigationQuery class >> direction: aSymbol [
	^ self directionStrategy: (MooseQueryAbstractDirectionStrategy fromSymbol: aSymbol)
]

{ #category : #'instance creation' }
MooseQueryNavigationQuery class >> directionStrategy: aStrategy [
	^ self new
		directionStrategy: aStrategy;
		yourself
]

{ #category : #accessing }
MooseQueryNavigationQuery >> associationSelectionStrategy: anObject [
	associationSelectionStrategy := anObject
]

{ #category : #accessing }
MooseQueryNavigationQuery >> directionStrategy [
	^ directionStrategy
]

{ #category : #accessing }
MooseQueryNavigationQuery >> directionStrategy: anObject [
	directionStrategy := anObject
]

{ #category : #query }
MooseQueryNavigationQuery >> execute [
	^ directionStrategy queryResultOn: receiver with: (self queryFor: receiver)
]

{ #category : #query }
MooseQueryNavigationQuery >> has: aFAMIXClassAssociation for: anEntity [
	"I know that we could use #do: here, but this algo takes too long on big model, so this is a speed up while the sista vm is not ready for production"

	| selectors |
	(self hasLocal: aFAMIXClassAssociation for: anEntity) ifTrue: [ ^ true ].
	"End condition"
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | (self has: aFAMIXClassAssociation for: (coll at: i)) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasFor: anEntity [
	| selectors |
	(self hasLocalFor: anEntity) ifTrue: [ ^ true ].
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | (self hasFor: (coll at: i)) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasLocal: aFAMIXClassAssociation for: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := directionStrategy msePropertiesOf: anEntity) size do:
		[ :ind | (anEntity perform: (properties at: ind) name) ifNotNil: [ :coll | coll asCollection do: [ :each | (each isOfType: aFAMIXClassAssociation) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasLocalFor: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := directionStrategy msePropertiesOf: anEntity) size do: [ :ind | (anEntity perform: (properties at: ind) name) ifNotNil: [ :coll | coll asCollection ifNotEmpty: [ ^ true ] ] ].
	^ false
]

{ #category : #initialization }
MooseQueryNavigationQuery >> initialize [
	super initialize.
	resultKindStrategy := MooseQueryNavigationAssociationKindStrategy.
	shouldCollectChildrenDependencies := true
]

{ #category : #query }
MooseQueryNavigationQuery >> queryFor: anEntity [
	"collects in aCollection all entities on the opposite side of associations with self
	 Opposite side depends on self strategy (incoming/outgoing)
	
	First collects entities from local (not inherited) properties
	Then get children entities of self and applies recurvively on them"

	| selectors |
	self queryLocalFor: anEntity.

	shouldCollectChildrenDependencies ifFalse: [ ^ result ].

	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self queryFor: (coll at: i) ] ] ].
	^ result
]

{ #category : #query }
MooseQueryNavigationQuery >> queryLocalFor: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := directionStrategy msePropertiesOf: anEntity) size do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | 
				"We ensure we have associations because non-reified associations were introduced in Moose"
				result
					addAll:
						(resultKindStrategy
							collectResultFrom: ((associationSelectionStrategy selectAssociationsIn: coll asCollection) collect: [ :res | directionStrategy ensureAssociation: res with: anEntity ])
							query: self) ] ].
	^ result
]

{ #category : #accessing }
MooseQueryNavigationQuery >> resultKindStrategy: anObject [
	resultKindStrategy := anObject
]

{ #category : #accessing }
MooseQueryNavigationQuery >> selectOnlyLocalDependencies [
	shouldCollectChildrenDependencies := false
]