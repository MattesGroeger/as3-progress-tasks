/*
 * Copyright (c) 2010 Mattes Groeger
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
package de.mattesgroeger.task.example.tasks
{
	import de.mattesgroeger.task.progress.ProgressTaskGroup;
	import de.mattesgroeger.task.util.FakeProgressTask;

	import org.spicefactory.lib.task.Task;

	public class SubTaskGroupFactory implements ProgressTaskGroupFactory
	{
		public function create():ProgressTaskGroup
		{
			var taskGroup:ProgressTaskGroup = new ProgressTaskGroup("ROOT");
			
			var task1:Task = new FakeProgressTask(300, "TASK 1 (300ms)");
			var task2:Task = getSubTaskGroup();
			var task3:Task = new FakeProgressTask(100, "TASK 3 (100ms)");
			
			taskGroup.addTaskWeighted(task1, 3);
			taskGroup.addTaskWeighted(task2, 8);
			taskGroup.addTaskWeighted(task3, 1);
			
			return taskGroup;
		}
		
		private function getSubTaskGroup():ProgressTaskGroup
		{
			var subTaskGroup:ProgressTaskGroup = new ProgressTaskGroup("SUBGROUP");
			
			subTaskGroup.addTaskWeighted(new FakeProgressTask(300, "SUB TASK 1"), 1);
			subTaskGroup.addTaskWeighted(new FakeProgressTask(300, "SUB TASK 2"), 1);
			subTaskGroup.addTaskWeighted(new FakeProgressTask(600, "SUB TASK 3"), 2);
			
			return subTaskGroup;
		}
	}
}