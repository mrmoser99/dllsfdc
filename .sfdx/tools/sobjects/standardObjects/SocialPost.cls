// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class SocialPost {
    global Id Id;
    global SObject Owner;
    global Id OwnerId;
    global Boolean IsDeleted;
    global String Name;
    global Datetime CreatedDate;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime LastModifiedDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime SystemModstamp;
    global Datetime LastViewedDate;
    global Datetime LastReferencedDate;
    global Case Parent;
    global Id ParentId;
    global SocialPersona Persona;
    global Id PersonaId;
    global SObject Who;
    global Id WhoId;
    global SocialPost ReplyTo;
    global Id ReplyToId;
    global String Headline;
    global String Content;
    global Datetime Posted;
    global String PostUrl;
    global String Provider;
    global String Handle;
    global String SpamRating;
    global String MediaType;
    global String MediaProvider;
    global String Sentiment;
    global String PostPriority;
    global String Status;
    global String StatusMessage;
    global String Recipient;
    global String RecipientType;
    global String MessageType;
    global String R6PostId;
    global String R6TopicId;
    global String R6SourceId;
    global String TopicType;
    global String ExternalPostId;
    global Datetime HarvestDate;
    global Boolean IsOutbound;
    global String PostTags;
    global String SourceTags;
    global String Classification;
    global Integer ThreadSize;
    global Integer CommentCount;
    global Integer Shares;
    global Integer ViewCount;
    global Integer InboundLinkCount;
    global Integer UniqueCommentors;
    global Integer LikesAndVotes;
    global String TopicProfileName;
    global String KeywordGroupName;
    global String EngagementLevel;
    global String AssignedTo;
    global ExternalSocialAccount OutboundSocialAccount;
    global Id OutboundSocialAccountId;
    global String ReviewedStatus;
    global String AttachmentUrl;
    global String AttachmentType;
    global User DeletedBy;
    global Id DeletedById;
    global String ResponseContextExternalId;
    global String LikedBy;
    global Double AnalyzerScore;
    global String Language;
    global Double ReviewScore;
    global Double ReviewScale;
    global User HiddenBy;
    global Id HiddenById;
    global String Notes;
    global String TruncatedContent;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<Case> Cases;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<NetworkActivityAudit> ParentEntities;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordAction> RecordActions;
    global List<RecordActionHistory> RecordActionHistories;
    global List<SocialPersona> Personas;
    global List<SocialPost> Replies;
    global List<SocialPostFeed> Feeds;
    global List<SocialPostHistory> Histories;
    global List<CaseChangeEvent> Source;
    global List<ContentVersion> FirstPublishLocation;
    global List<FeedComment> Parent;
    global List<FlowRecordRelation> RelatedRecord;

    global SocialPost () 
    {
    }
}