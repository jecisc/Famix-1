"
Description
--------------------

I am a strategy managing the behavior of the Moose Queries depending on directions in the case where the query require the outgoing associations.
"
Class {
	#name : #MooseQueryOutgoingDirectionStrategy,
	#superclass : #MooseQueryAbstractDirectionStrategy,
	#category : #'Moose-Query-Strategies'
}

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> allAssociationTypesFor: anEntity [
	^ anEntity allOutgoingAssociationTypes
]

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> associationTypesFor: anEntity [
	^ anEntity outgoingAssociationTypes
]

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> determinatingSymbol [
	^ #out
]

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> msePropertiesOf: anEntity [
	^ anEntity outgoingMSEProperties
]

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> queryResultOn: anEntity with: aCollection [
	^ anEntity createOutgoingQueryResultWith: aCollection
]

{ #category : #accessing }
MooseQueryOutgoingDirectionStrategy class >> symbolToCollectEntities [
	"I should return a Symbol to collect entities. For example an Incoming direction will have #from as symbol to collect entities."

	^ #target
]
