/*
 * Copyright (c) 2011 Peter Hoeche
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package de.mattesgroeger.task.util
{
	import de.mattesgroeger.task.progress.ProgressTask;

	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	public class LoaderInfoProgressTask extends ProgressTask
	{
		private var _loaderInfo : LoaderInfo;

		public function LoaderInfoProgressTask( loaderInfo : LoaderInfo, label : String = null )
		{
			super( label );

			setCancelable( false );
			setSuspendable( false );
			setSkippable( false );

			_loaderInfo = loaderInfo;
		}

		public function get loaderInfo() : LoaderInfo
		{
			return _loaderInfo;
		}

		protected override function doStart() : void
		{
			super.doStart();

			if ( loaderInfo.bytesTotal != 0 && loaderInfo.bytesLoaded == loaderInfo.bytesTotal )
				complete();
			else
				addListener();
		}

		protected function handleComplete( event : Event ) : void
		{
			removeListener();
			complete();
		}

		protected function handleError( event : ErrorEvent ) : void
		{
			removeListener();
			progress( 1 );
			error( "Error loading " + loaderInfo.loaderURL + ": " + event.text );
		}

		protected function handleProgress( progressEvent : ProgressEvent ) : void
		{
			if ( progressEvent.bytesTotal == 0 )
				progress( 0 );
			else
				progress( progressEvent.bytesLoaded / progressEvent.bytesTotal );
		}

		private function addListener() : void
		{
			loaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleError );
			loaderInfo.addEventListener( ProgressEvent.PROGRESS, handleProgress );
			loaderInfo.addEventListener( Event.COMPLETE, handleComplete );
		}

		private function removeListener() : void
		{
			loaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, handleError );
			loaderInfo.removeEventListener( ProgressEvent.PROGRESS, handleProgress );
			loaderInfo.removeEventListener( Event.COMPLETE, handleComplete );
		}
	}
}
