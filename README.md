AS3 Progress Tasks
==================

This library provides an easy way to track progress with the [spicelib task framework](http://www.spicefactory.org/parsley/docs/2.3/manual/task.php). 

Task framework? That's what the documentation says: "The Task Framework is a general abstraction for asynchronous operations. It allows nesting / grouping of Tasks in TaskGroup instances for concurrent or sequential execution." ([Read on here for more information](http://www.spicefactory.org/parsley/docs/2.3/manual/task.php))

This library goes one step further by adding `ProgressTask`, `ProgressTaskGroup` and `ProgressTaskEvent`. They allow you to track the overall progress of your tasks. Besides it provides default progress task implementations for the most common as3 loaders.

**Use cases for this library:**

- Load files (swf, xml, mp3, image, binary, css) via tasks
- Mix file loading with other tasks (backend calls, setup tasks, etc.)
- Get an overall progress for everything
- Configure loading in different abstraction layers via `TaskGroups`

Change log
----------

**0.2.0**

* **[Added]** Abstract `doComplete` method in `AbstractLoaderTask` which is called after the results have been set
* **[Changed]** Label is not required in constructor of `ProgressTasks` anymore (now optional)
* **[Changed]** General clean up (doesn't effect the external API)

**0.1.0**

* **[Added]** Progress task
* **[Added]** Sequential progress task group
* **[Added]** Progress tasks implementations for CSS, Images, MP3, SWF, XML and Binaries
* **[Added]** FakeProgressTask for emulating progress

Usage
-----

To get a quick impression how the tasks work, have a look at the `example` folder in this project or download the demo files.

The following example creates a task group to load two files. By listening for the progress event on the group you get the overall progress.

	var taskGroup:ProgressTaskGroup = new ProgressTaskGroup();
	taskGroup.addEventListener(ProgressTaskEvent.PROGRESS, handleProgress);
	taskGroup.addTask(new SwfLoaderTask("assets/Module.swf"));
	taskGroup.addTask(new XmlLoaderTask("assets/config.xml"));
	taskGroup.start();
	
	function handleProgress(event:ProgressTaskEvent):void
	{
		trace(event.progress);
	}

If your tasks vary greatly in size, you can define a weight for each task. The weight values are relative to each other. You can either use percentage numbers, file sizes or your own units. It's up to you:

	var taskGroup:ProgressTaskGroup = new ProgressTaskGroup();
	taskGroup.addTaskWeighted(swfLoader, 80);
	taskGroup.addTaskWeighted(xmlLoader, 20);
	taskGroup.start();

To allow the progress tracking in bigger application – over different layers – you can nest as many groups as you want. The `ProgressTaskGroup` will then provide you always with the total progress:

	var xmlGroup:ProgressTaskGroup = new ProgressTaskGroup();
	xmlGroup.addTask(xmlLoader1);
	xmlGroup.addTask(xmlLoader2);
	
	var rootGroup:ProgressTaskGroup = new ProgressTaskGroup();
	rootGroup.addTaskWeighted(swfLoader, 80);
	rootGroup.addTaskWeighted(xmlGroup, 20);
	rootGroup.start();

Note: You can mix normal task and weighted task assignments. But keep in mind, that the normal tasks always have a weight of 1 internally. 

You can also assign non-progress tasks to a `ProgressTaskGroup`. But the overall progress won't be updated while the assigned tasks are executed.

Roadmap
-------

- Provide ASDocs
- Provide more examples
- Add handling for synchronous security errors