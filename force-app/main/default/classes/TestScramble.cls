@isTest(seealldata=true)

public with sharing class TestScramble {
 		
	static testmethod void test1(){
		
		Scramble1 job = new Scramble1();
        System.enqueueJob(job);	
    }

    static testmethod void test2(){

        Scramble2 job2 = new Scramble2();
        System.enqueueJob(job2);	
    }

    static testmethod void test3(){

        Scramble3 job3 = new Scramble3();
        System.enqueueJob(job3);	
    }

    static testmethod void test4(){ 

        Scramble4 job4 = new Scramble4();
        System.enqueueJob(job4);	
    }

    static testmethod void test5(){
    
        Scramble5 job5 = new Scramble5();
        System.enqueueJob(job5);	
    }

    static testmethod void test6(){

        Scramble6 job6 = new Scramble6();
        System.enqueueJob(job6);	
		
 	}
}