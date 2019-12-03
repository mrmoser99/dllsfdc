public class PermissionSetCreator {
    PermissionSet ps;
    
    public PermissionSetCreator(String PermissionSetName) {
        if (String.isNotBlank(PermissionSetName)) {
            try {
            List<PermissionSet> psList = new List<PermissionSet>();
                psList = [SELECT Id, Name, label FROM PermissionSet WHERE Name = :PermissionSetName LIMIT 1];
                if(psList.size()>0){
                ps = psList.get(0);
                }
                
                else{
                 System.debug('Creating new PermissionSet with the name ' + PermissionSetName);
                 ps = new PermissionSet();
                 ps.Name = PermissionSetName;
                 ps.label = PermissionSetName;
                 insert ps;
                }
            } catch (Exception e) {
                
            }
            System.debug('PS -> ' + ps);
        }
    }
    
    public void grantReadOnlyPermissions(List<String> sObjList) {
        if (ps != null && sObjList.size() > 0) {
            List<ObjectPermissions> permissionList =  new List<ObjectPermissions>();
            for(String sObj : sObjList) {
                //insert Object permission for Addenda Record
                ObjectPermissions op = new ObjectPermissions();
                op.parentId = ps.Id;
                op.SobjectType = sObj;
                op.PermissionsRead = true;
                permissionList.add(op);
            }
            insert permissionList;
        }
    }
    
    public void grantRCEPermissions(List<String> sObjList) {
        if (ps != null && sObjList.size() > 0) {
            List<ObjectPermissions> permissionList =  new List<ObjectPermissions>();
            for(String sObj : sObjList) {
                //insert Object permission for Addenda Record
                ObjectPermissions op = new ObjectPermissions();
                op.parentId = ps.Id;
                op.SobjectType = sObj;
                op.PermissionsCreate = true;
                op.PermissionsRead = true;
                op.PermissionsEdit = true;
                permissionList.add(op);
            }
            insert permissionList;
        }
    }
    
    public void ReadOnlyPermissionsWithFields(List<String> sObjList) {
        if (ps != null && sObjList.size() > 0) {
            List<ObjectPermissions> permissionList =  new List<ObjectPermissions>();
            List<fieldPermissions> fieldPermisstionList =  new List<fieldPermissions>();
            for(String sObj : sObjList) {
              if(sObj!=null){
              system.debug('=========='+sObj+'=====');
                ObjectPermissions op = new ObjectPermissions();
                op.parentId = ps.Id;
                op.SobjectType = sObj;
                op.PermissionsRead = true;
               // op.PermissionsViewAllRecords = true;
                permissionList.add(op);
                
                SObjectType currentObject = Schema.getGlobalDescribe().get(sObj);
                Map<String, Schema.SObjectField> fieldMap = currentObject.getDescribe().fields.getMap();
                //System.debug('SObj - > '+sObj+ ' Map -> '+fieldMap);
                
                if (fieldMap != null) {
                    for(Schema.SObjectField field : fieldMap.values()) {
                    Schema.DescribeFieldResult dscField = field.getDescribe();
                    if (dscField.isCustom() && dscField.isPermissionable()) {
                        fieldPermissions fp = new fieldPermissions();
                        fp.ParentId = ps.Id;
                        fp.SobjectType = sObj;
                        fp.Field = sObj + '.' + field;
                        fp.PermissionsRead = true;
                        fieldPermisstionList.add(fp);
                    }
                 }
                }
                }
             }
            insert permissionList;
            insert fieldPermisstionList;
        }
    }
    
    public void RCEPermissionsWithFields(List<String> sObjList) {
        if (ps != null && sObjList.size() > 0) {
            List<ObjectPermissions> permissionList =  new List<ObjectPermissions>();
            List<fieldPermissions> fieldPermisstionList =  new List<fieldPermissions>();
            for(String sObj : sObjList) {
                if(sObj!=null){
                 system.debug('=========='+sObj+'=====');
                ObjectPermissions op = new ObjectPermissions();
                op.parentId = ps.Id;
                op.SobjectType = sObj;
                op.PermissionsCreate = true;
                //op.PermissionsDelete = true;
                op.PermissionsEdit = true;
                //op.PermissionsModifyAllRecords = true;
                op.PermissionsRead = true;
               // op.PermissionsViewAllRecords = true;
                
                permissionList.add(op);
                
                SObjectType currentObject = Schema.getGlobalDescribe().get(sObj);
                Map<String, Schema.SObjectField> fieldMap = currentObject.getDescribe().fields.getMap();
                //System.debug('SObj - > '+sObj+ ' Map -> '+fieldMap);
                for(Schema.SObjectField field : fieldMap.values()) {
                    Schema.DescribeFieldResult dscField = field.getDescribe();
                    if (dscField.isCustom() && dscField.isPermissionable()) {
                        fieldPermissions fp = new fieldPermissions();
                        fp.ParentId = ps.Id;
                        fp.SobjectType = sObj;
                        fp.Field = sObj + '.' + field;
                        fp.PermissionsRead = true;
                        if (dscField.isUpdateable()) {
                            fp.PermissionsEdit = true;
                        }
                        fieldPermisstionList.add(fp);
                    }
                 }
                 }
            }
            insert permissionList;
            insert fieldPermisstionList;
        }
    }  
    }