/*
 PureMVC Utility - Asynchronous Stub 
 Copyright (c) 2008, Philip Sexton <philip.sexton@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package org.puremvc.as3.utilities.asyncstub.model
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
    
    /**
    *   Can be used to simulate an asynchrounous activity.  Instantiate as a proxy, with or without
    *   a name. The async activity is started by invoking the <code>asyncAction</code> method. There 
    *   cannot be more than one activity running per stub instance.
    *   <p>
    *   Uses a random number for the async delay.  Set the max delay in msecs using the 
    *   <code>maxDelayMSecs</code> property.</p>
    *   <p>
    *   When the async action completes, it invokes either a result method or a fault method,
    *   similar to IResponder.  Use the <code>probabilityOfFault</code> property to govern random selection of 
    *   the method.</p>
    *   <p>
    *   Includes the facility to set a <code>token</code> property that will be returned to the 
    *   result/fault method, enabling the client app to track the stub instance that invoked the 
    *   result/fault.  This facility is optional.  If the token is not set, no arguments are passed
    *   to the result/fault method.</p>
    *   <p>
    *   See the demo StartupAsOrdered for an example of use.</p>
    */
	public class AsyncStubProxy extends Proxy implements IProxy
	{
	    protected const ONE_ONLY_MSG :String = 
	        "AsyncStubProxy: Cannot have more than one async activity running per stub";

		public var maxDelayMSecs :int = 15000; // 15 secs
		public var probabilityOfFault :Number = 0.0;
		public var token :Object;

		private var clientResultFunction :Function;
		private var clientFaultFunction :Function;
		private var asyncInProgress :Boolean = false;

		public function AsyncStubProxy( name :String =null ) 
		{
			super( name );
		}

        public function asyncAction( resultFunction :Function, faultFunction :Function =null) :void {
            if (asyncInProgress)
                throw Error ( ONE_ONLY_MSG );

            asyncInProgress = true;
            clientResultFunction = resultFunction;
            clientFaultFunction = faultFunction;

            // 0 <= Math.random() < 1
            var onCompletion :Function = calcCompletionFunction();
            var msecsDelay :Number = Math.random() * maxDelayMSecs;
            var timer :Timer = new Timer( msecsDelay, 1 );
            timer.addEventListener( TimerEvent.TIMER, onCompletion );
            timer.start();
        }

        protected function calcCompletionFunction() :Function {
            if ( clientFaultFunction == null ) {
                return onResult;
            }
            else if ( probabilityOfFault <= .01 ) {
                return onResult;
            }
            else if ( probabilityOfFault >= .99 ) {
                return onFault;
            }
            else if ( Math.random() <= probabilityOfFault )
                return onFault;
            else
                return onResult;
        }

        protected function onResult( event :Event ) :void {
            asyncInProgress = false;
            if ( token != null )
                clientResultFunction( token );
            else
                clientResultFunction();
        }

        protected function onFault( event :Event ) :void {
            asyncInProgress = false;
            if ( token != null )
                clientFaultFunction( token );
            else
                clientFaultFunction();
        }      

	}
}