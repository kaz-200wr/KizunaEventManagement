@isTest
private class Kizuna_CheckInCountTriggerTest {
    static Id createParticipantData() {
        Kizuna_Request__c request = new Kizuna_Request__c(
            LastName__c = 'test',
            FirstName__c = 'test'
        );
        insert request;

        Kizuna_Volunteer__c volunteer = new Kizuna_Volunteer__c(
            Request__c = request.Id,
            StartDate__c = Date.today()
        );
        insert volunteer;

        Kizuna_Candidate__c candidate = new Kizuna_Candidate__c(
            LastName__c = 'test',
            FirstName__c = 'test'
        );
        insert candidate;

        Kizuna_Participant__c participant = new Kizuna_Participant__c(
            Volunteer__c = volunteer.Id,
            Candidate__c = candidate.Id
        );
        insert participant;

        return participant.Id;
    }

    static testMethod void insertTest() {
        // init
        ID pid = createParticipantData();

        // test
        Test.startTest();
        Kizuna_CheckIn__c checkin1 = new Kizuna_CheckIn__c(
            Participant__c = pid
        );
        insert checkin1;
        Kizuna_CheckIn__c checkin2 = new Kizuna_CheckIn__c(
            Participant__c = pid
        );
        insert checkin2;
        Test.stopTest();

        // check
        Kizuna_Participant__c p = [Select NumberOfCheckin__c From Kizuna_Participant__c Where Id = :pid];
        System.assertEquals(2, p.NumberOfCheckin__c);
    }

    static testMethod void deleteTest() {
        // init
        ID pid = createParticipantData();

        Kizuna_CheckIn__c checkin1 = new Kizuna_CheckIn__c(
            Participant__c = pid
        );
        insert checkin1;
        Kizuna_CheckIn__c checkin2 = new Kizuna_CheckIn__c(
            Participant__c = pid
        );
        insert checkin2;

        // test
        Test.startTest();
        delete checkin1;
        delete checkin2;
        Test.stopTest();

        // check
        Kizuna_Participant__c p = [Select NumberOfCheckin__c From Kizuna_Participant__c Where Id = :pid];
        System.assertEquals(0, p.NumberOfCheckin__c);
    }
}