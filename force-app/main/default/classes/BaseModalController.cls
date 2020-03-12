public virtual class BaseModalController {

    public Boolean closeModal {get; set;}
    public String modalParam {get; set;}

    public BaseModalController(){
        closeModal = false;
        if(ApexPages.currentPage() != null && ApexPages.currentPage().getParameters().get('modal') != null){
          modalParam = ApexPages.currentPage().getParameters().get('modal');
        }
    }

    public PageReference actionSuccessful(String href){
       if (modalParam == 'true') {
           closeModal = true;
           return null;
       } else {
           PageReference ref = new PageReference(TerminationUtil.getSafeUrl(href));
           return ref;
       }
    }

    public PageReference actionSuccessfulPageRef(PageReference pageRefId){
       if (modalParam == 'true') {
           closeModal = true;
           return null;
       } else {
           return pageRefId;
       }
    }
}