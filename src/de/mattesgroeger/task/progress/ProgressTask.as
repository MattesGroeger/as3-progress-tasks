/*
 * Copyright (c) 2011 Mattes Groeger
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
package de.mattesgroeger.task.progress
{
	import flash.utils.getQualifiedClassName;
	import org.spicefactory.lib.util.ClassUtil;
	import de.mattesgroeger.task.progress.events.ProgressTaskEvent;

	import org.spicefactory.lib.errors.IllegalArgumentError;
	import org.spicefactory.lib.task.Task;
	
	public class ProgressTask extends Task implements IProgressTask
	{
		private var _label:String;

		public function ProgressTask(label:String = null)
		{
			_label = (label == null) ? "[ProgressTask]" : label;
			
			setName(label);
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(label:String):void
		{
			_label = label;
		}
		
		protected function progress(progress:Number):void
		{
			if (progress < 0 || progress > 1)
				throw new IllegalArgumentError("Wrong progress in Class: '" + getQualifiedClassName(this) + "'.Allowed progress range reaches from 0 to 1, but is currently " + progress);
			
			if (parent != null && parent is IProgressTaskGroup)
				IProgressTaskGroup(parent).progressChild(this, progress, _label);
			
			dispatchEvent(new ProgressTaskEvent(ProgressTaskEvent.PROGRESS, progress, _label));
		}
		
		public override function toString() : String
		{
			return _label;
		}
	}
}