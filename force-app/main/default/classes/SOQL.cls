/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Your Name
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        return [SELECT Id, LastName, Company, Phone, Email FROM Lead WITH SECURITY_ENFORCED];
        
    }
    

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        List<Contact> contacts = new List<Contact>([SELECT Id, Name, FirstName, LastName 
                                                    FROM Contact WHERE FirstName = 'John']);
        return contacts;
    }
    
        /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
        List<Id> contactIds = new List<Id>();
        List<Contact> contacts = new List<Contact>([SELECT Id, LastName FROM Contact 
                                                    WHERE LastName = 'Smith' OR LastName = 'Jones']);
        for (Contact contact : contacts) {
            contactIds.add(Contact.Id);
        }
        return contactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(Id accountId) {
        List<Opportunity> closedWonOppsList = new List<Opportunity>([
            SELECT Id, AccountId, Amount, Name, StageName, CloseDate
            FROM Opportunity 
            WHERE AccountId = :accountId
            AND StageName = 'Closed Won' WITH SECURITY_ENFORCED]);

        return closedWonOppsList;

    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {
        return [SELECT COUNT() FROM Account WITH SECURITY_ENFORCED];
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
        Map<Id, Task> mapOfTasksAndSubjects = new Map<Id, Task>();
        List<Task> ListofTasksDue = [
            SELECT Id, Subject, ActivityDate 
            FROM Task 
            WHERE ActivityDate = NEXT_N_DAYS:7 WITH SECURITY_ENFORCED
        ];
        for (Task task : ListofTasksDue) {
            mapOfTasksAndSubjects.put(task.Id , task);
        }
        return mapOfTasksAndSubjects;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
        List<Contact> contactsList = new List<Contact>([
            SELECT Id, Name, FirstName, LastName, Email 
            FROM Contact
            WHERE Email LIKE '%example.com%' WITH SECURITY_ENFORCED
        ]);
        return contactsList;
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String searchPattern = '%' + keyword + '%';
        List<Opportunity> oppsList = new List<Opportunity>([
            SELECT Id, AccountId, Name, StageName, CloseDate
            FROM Opportunity 
            WHERE Name LIKE :searchPattern WITH SECURITY_ENFORCED
        ]);
        return oppsList; 
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<Case> myCases = new List<Case>([
            SELECT Id, Origin, Status, AccountId 
            FROM Case 
            WHERE Origin != null AND (Origin != 'Email' AND Origin != 'Web') WITH SECURITY_ENFORCED
        ]);                                               
        return myCases;
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
    String searchPattern2 = '%' + keyword + '%';
    List<Lead> myfilteredLeads = new List<Lead>([
        SELECT Id, Name, LastName, Company, Phone, Email, LeadSource, Title
        FROM Lead 
        WHERE LeadSource =:leadSource 
        OR Title LIKE :searchPattern2 WITH SECURITY_ENFORCED
    ]);
    return myfilteredLeads;

    }

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String> myListOfContactLastNames = new List<String>();
        List<Contact> contactListFromAccounts = new List<Contact>([
            SELECT Id, AccountId, Name, LastName 
            FROM Contact 
            WHERE AccountId = :accountId WITH SECURITY_ENFORCED
        ]);
        for (Contact con : contactListFromAccounts) {
            myListOfContactLastNames.add(con.LastName);
        }
        return myListOfContactLastNames; 
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        List<AggregateResult> results = [
            SELECT SUM(Amount) totalAmount
            FROM Opportunity
            WHERE StageName LIKE :stage 
            AND Amount >= 10000 WITH SECURITY_ENFORCED
            ];

        Decimal totalAmount = 0;
        if (!results.isEmpty()) {
            AggregateResult ar = results[0];
            totalAmount = (Decimal) ar.get('totalAmount');
            }            
            return totalAmount;
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [
            SELECT Id, Name 
            FROM Account WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        
        return [
            SELECT Id, Name, AccountId, StageName, Amount, CloseDate
            FROM Opportunity
            WHERE Amount > 100000 WITH SECURITY_ENFORCED
            ORDER BY CloseDate ASC
            LIMIT 5
        ]; 
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [
            SELECT Id, Name, Birthdate
            FROM Contact
            WHERE Birthdate = THIS_YEAR WITH SECURITY_ENFORCED
            ORDER BY Birthdate DESC
            LIMIT 3 
        ]; 
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [
            SELECT Id, CreatedDate, IsClosed
            FROM Case
            WHERE IsClosed = false WITH SECURITY_ENFORCED
            LIMIT 10 
            OFFSET 5 
        ];
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> idSet = new Set<Id>();
        List<Case> listOfQueriedCases = new List<Case>([
            SELECT Id, AccountId 
            FROM Case 
            WHERE AccountId  =:accountId WITH SECURITY_ENFORCED
            ]);
    
        if (!listOfQueriedCases.isEmpty()) {
            for (Case cases : listOfQueriedCases) {
            idSet.add(cases.Id);
            }
        }
        return idSet; 
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        List<Account> queriedAccounts = new List<Account>([
            SELECT Id, Name, BillingCountry
            FROM Account
            WHERE BillingCountry !=:country WITH SECURITY_ENFORCED
        ]);

        if (!queriedAccounts.isEmpty()) {
            for (Account acc : queriedAccounts) {
            accountIdsToNames.put(acc.Id , acc.Name);
            }
    }
        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {

        List<Contact> contactList = new List<Contact>([
            SELECT AccountId, Account.Name
            FROM Contact
            WHERE Id =:contactId WITH SECURITY_ENFORCED
        ]); 

        if (!contactList.isEmpty() && contactList[0].Account != null) {
            return contactList[0].Account.Name;
        } else {
            return null; 
        }
    }

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */

    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        List<Account> accountListWithOpps = new List<Account>([
            SELECT Id, Name, (SELECT Id, Name, StageName, CloseDate, AccountId FROM Opportunities)
            FROM Account
            WHERE Id =:accountId WITH SECURITY_ENFORCED
        ]);

        if (!accountListWithOpps.isEmpty()) {
            return accountListWithOpps[0];
        }
        return accountListWithOpps[1]; 
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<Contact> finalList = new List<Contact>();
        List<Account> accountList = new List<Account>([
            SELECT Id, Name, BillingState, (SELECT Id, MailingState FROM Contacts)
            FROM Account
            WHERE Id =:accountId WITH SECURITY_ENFORCED
        ]);
        
        if (accountList[0] != null) {
            String billingState = accountList[0].BillingState;
        List<Contact> contactList = new List<Contact>([
            SELECT Id, LastName, AccountId, MailingState
            FROM Contact 
            WHERE MailingState =:billingState WITH SECURITY_ENFORCED
        ]);

        for (Contact con : contactList) {
            if (con.MailingState == billingState) {
                finalList.add(con);
                }
            } 
        }   
        return finalList;
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leadList = [
            SELECT Id, Email
            FROM Lead
            WHERE Id IN :leadIds WITH SECURITY_ENFORCED
        ];
    
        Set<String> emailDomains = new Set<String>();
        for (Lead lead : leadList) {
            if (lead.Email != null && lead.Email.indexOf('@') != -1) {
                emailDomains.add(lead.Email.split('@')[1]);
            }
        }
    
        String query = 'SELECT Id, Website FROM Account WHERE';
        Boolean isFirst = true;
        for (String domain : emailDomains) {
            if (!isFirst) {
                query += ' OR';
            }
            query += ' Website LIKE \'%' + domain + '%\'';
            isFirst = false;
        }
    
        List<Account> finalAccountList = Database.query(query);
        return finalAccountList;
    }
    
    

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>([
            SELECT Id, Quantity, PricebookEntryId, UnitPrice
            FROM OpportunityLineItem
            WHERE OpportunityId =:origOppId WITH SECURITY_ENFORCED
        ]);
    
        List<OpportunityLineItem> olisToInsert = new List<OpportunityLineItem>();
        for (Id id : cloneOppIds) {
            for (OpportunityLineItem oli : olis) {
                OpportunityLineItem newOli = oli.clone(false, true);
                Integer numOli = (Integer)Math.floor(Math.random() * 10) + 1;
                newOli.OpportunityId = id;
                newOli.Quantity = oli.Quantity + numOli;

                olisToInsert.add(newOli);
            }
        }
        if (!olisToInsert.isEmpty()) {
            insert as system olisToInsert;
        }
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        List<Opportunity> closedWonOppDetails = new List<Opportunity>([
            SELECT Id, Name, Account.Name, Owner.Name, StageName
            FROM Opportunity
            WHERE StageName = 'Closed Won' WITH SECURITY_ENFORCED
        ]);
        return closedWonOppDetails; 
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        List<Contact> queriedContacts = new List<Contact>([
            SELECT Id, Name, FirstName, LastName, AccountId 
            FROM Contact
            WHERE AccountId IN :accountIds WITH SECURITY_ENFORCED
        ]);

        Map<Id, String> accountToContactMap = new Map<Id, String>();
        if (!queriedContacts.isEmpty()) {
            for (Contact con : queriedContacts) {
                accountToContactMap.put(con.AccountId , con.Id);
                }
            }    
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for (Opportunity opp : closedWonOpps) {
            if (accountToContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId);
                oppsToUpdate.add(opp);
            }
        }
        update as system oppsToUpdate;
    }
}