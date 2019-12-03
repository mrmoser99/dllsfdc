public class ATS_util{

    public class lessee { 
        String name;
        String primaryPhoneNumber;
        address address;
            
        public lessee(String name, String primaryPhoneNumber, address address) { 
            this.name = name;
            this.primaryPhoneNumber = primaryPhoneNumber;
            this.address = address;
        }
    }

    public class address{ 
        String addressLine1;
        String city;
        String state;
        String postalCode;
            
        public address(String addressLine1, String city, String state, String postalCode) { 
            this.addressLine1 = addressLine1;
            this.city = city;
            this.state = state;
            this.postalCode = postalCode;
        }
    }

    public class asset { 
        String assetDescription;
        Integer quantity;
        String manufacturer;
        List<cost> costs = new List<cost>();

        public asset(String assetDescription, Integer quantity, String manufacturer, list<cost> costs ) { 
            this.assetDescription = assetDescription;
            this.quantity = quantity;
            this.manufacturer = manufacturer;
            this.costs = costs;
        }
    }

    public class cost{ 
        String costTypeCode;
        Decimal amount;
            
        public cost(String costTypeCode, Decimal amount) { 
            this.costTypeCode = costTypeCode;
            this.amount = amount;
        }
    }

    public class structure{ 
        String purchaseOption;
        Integer termInMonths;
        String frequency;
        Decimal totalAmountFinanced;
        Decimal rateFactor;
        Decimal leasePayment;
            
        public structure(String purchaseOption, Integer termInMonths, String frequency, Decimal totalAmountFinanced, Decimal rateFactor,  Decimal leasePayment) { 
            this.purchaseOption = purchaseOption;
            this.termInMonths = termInMonths;
            this.frequency = frequency;
            this.totalAmountFinanced = totalAmountFinanced;
            this.rateFactor = rateFactor;
            this.leasePayment = leasePayment;
        }
    }

}