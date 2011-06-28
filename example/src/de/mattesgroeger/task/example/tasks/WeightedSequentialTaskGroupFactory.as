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
package de.mattesgroeger.task.example.tasks
{
	import de.mattesgroeger.task.progress.IProgressTaskGroup;
	import de.mattesgroeger.task.progress.SequentialProgressTaskGroup;
	import de.mattesgroeger.task.util.FakeProgressTask;

	import org.spicefactory.lib.task.Task;

	public class WeightedSequentialTaskGroupFactory implements ProgressTaskGroupFactory
	{
		public function create():IProgressTaskGroup
		{
			var taskGroup:SequentialProgressTaskGroup = new SequentialProgressTaskGroup("ROOT");
			
			var task1:Task = new FakeProgressTask(500,  "TASK 1 (500ms, weight 2)");
			var task2:Task = new FakeProgressTask(2000, "TASK 2 (2000ms, weight 8)");
			var task3:Task = new FakeProgressTask(250,  "TASK 3 (250ms, weight 1)");
			
			taskGroup.addTaskWeighted(task1, 2);
			taskGroup.addTaskWeighted(task2, 8);
			taskGroup.addTaskWeighted(task3, 1);
			
			return taskGroup;
		}
	}
}