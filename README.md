A concise and powerful Flutter package that implements the **MVVM** (*Model-View-ViewModel*)
architecture.
Built on top of **Riverpod** for state management, this package provides a seamless and efficient
way to
handle the state of the view in your Flutter applications. With a clean separation of concerns and a
reactive approach, it simplifies the development process and enhances the maintainability of your
codebase. Empower your Flutter projects with the **MVVM** architecture and leverage the capabilities
of
**Riverpod** for efficient state management.

## Features 🎯

* **MVVM Architecture:** Utilize the Model-View-ViewModel (MVVM) architecture pattern to ensure a
  clear separation of concerns and enhance code organization and maintainability.

* **FlView Class:** Render the view by extending the FlView class. Override methods for building
  different states, including Data State, Empty State, Error State, and Loading State. Customize the
  view based on the current state of the application.

* **FlViewModel Class:** Handle the state of the view by extending the FlViewModel class. Link the
  custom view to the view model using a generic type and a method. Implement the createViewModel()
  method to return an FlViewModel object.

* **Container Widget:** Specify a container widget that wraps the entire view. This allows users to
  customize the layout and appearance of the view according to their needs.

## Getting started 🚀

Before doing anything with the package wrap your **App** with a `ProviderScope`

```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

This ensures that the necessary providers and state management capabilities are available throughout
your Flutter App

## Usage 🔨

* [The ViewModel](#the-viewmodel)
    * [Create a ViewModel 🧩](#create-a-viewmodel-)
    * [Stateful ViewModel 💾](#stateful-viewmodel-)
    * [Initialize the state of ViewModel 🏁](#initialize-the-state-of-a-viewmodel-)
    * [onInit 🌱](#oninit-)
    * [onDispose ♻️](#ondispose-)
    * [refresh and refreshState 🔄](#refresh-and-refreshstate-)
    * [Loading State ⏳](#loading-state-)
    * [Data State 📊](#data-state-)
    * [Future Data ⏭](#future-data-)
    * [Empty State 💨](#empty-state-)
    * [Error State ❗](#error-state-)
* [The View 👀](#the-view-👀)
    * [Create a View 🖌️](#create-a-view-)
    * [Link a View to a ViewModel 🔗](#link-a-view-to-a-viewmodel-)
    * [Initialize the ViewModel with parameters 🎛️](#initialize-the-viewmodel-with-parameters-)
    * [The UI states of a View 🎨](#the-ui-states-of-a-view-)
    * [Wrapping the View with a Container 📦](#wrapping-the-view-with-a-container-)

### The ViewModel

#### *Create a ViewModel* 🧩

To create a **ViewModel**, simply create a class that extends the `FlViewModel` class

```dart
class MyViewModel extends FlViewModel {}
```

#### *Stateful ViewModel* 💾

The state of each **ViewModel** is accessible using the getter `value`

```dart

MyViewModel viewModel = MyViewModel();
dynamic state = viewModel.value;
```

As you can see the type of the state is `dynamic` but you can set the type to whatever you want
using a generic type

```dart

MyViewModel viewModel = MyViewModel<String>();
String state = viewModel.value;
```

📝 The actual state of `FlViewModel<T>` is represented by an `AsyncValue<T>`. In the example
mentioned
above, the state is specifically an `AsyncValue<String>`.
However, it's important to note that when accessing the getter `value`, it returns only the value of
the `AsyncValue` instead of the entire state instance.

#### *Initialize the state of a ViewModel* 🏁

When a `FlViewModel` instance gets created, it builds its state using the return value from
the `build()` method.
By default the `build()` method of an `FlViewModel` returns null.

You can override it to return the initial state of your **ViewModel**

```dart
class UsersListViewModel extends FlViewModel<List<User>> {
  @override
  FutureOr<List<User>?> build() {
    return UsersRepository
        .getAllUsers(); // In this example the initial state will be all the users returned from the UserRepository
  }
}
```

#### *onInit* 🌱

`onInit()` is a useful method that allows you to run code typically for initializing parameters,
immediately after the **View** is initialized

```dart
class MyViewModel extends FlViewModel {
  @override
  void onInit() {
    // This code will run only once when the associated View is initialized.
  }
}
```

📝 This method is executed only once.

#### *onDispose* ♻️

`onDispose()` is a useful method that allows you to run code just before the associated **View** is
is disposed.

```dart
class MyViewModel extends FlViewModel {
  @override
  void onDispose() {
    // This code will run when the associated View is being disposed
    // You might want to release resources, dispose of a disposable state, stop a timer, etc...
  }
}
```

#### *refresh and refreshState* 🔄

The `refresh()` method triggers a redraw of the **View**. On the other hand, the `refreshState()`
rebuilds the **ViewModel** state by invoking the `build()` method

#### *Loading State* ⏳

To display the *Loading state* you can use the built-in `setLoading()` method:

```dart
class MyViewModel extends FlViewModel {

  void loadUsers() async {
    setLoading(); // This will cause the View to render the loading UI state
    // Alternatively, you can use:
    // state = const AsyncValue.loading();
    // or
    // state = const AsyncLoading();

    /*...Continue loading users...*/
  }
}
```

By calling `setLoading()`, you trigger the **View** to render the loading UI state, indicating that
data
is being fetched or processed. Alternatively, you can directly assign `AsyncValue.loading()` or
`AsyncLoading()` to the state to achieve the same effect.

#### *Data State* 📊

To display the *Data state* you can use the built-in `setData()` method:

```dart
class CounterViewModel extends FlViewModel<int> {
  @override
  FutureOr<int?> build() {
    return 0;
  }

  void incrementCounter() {
    int currentValue = value ?? 0;
    int newValue = currentValue + 1;
    setData(newValue); // This will cause the view to render the new Data


    // Alternatively you can use: 
    // state = AsyncValue.data(newValue); 
    // or
    // state = AsyncData(newValue);

  }
}
```

By calling `setData(newValue)`, you update the **ViewModel** state with the new value, which
triggers the **View** to render the updated Data state. Alternatively, you can directly
assign `AsyncValue.data(newValue)` or `AsyncData(newValue)` to the state to achieve the same effect.

#### *Future Data* ⏭

If you need to set the data state from a `Future`, you can use the built-in `setFutureData()`
method, which accepts your future as a parameter:

```dart
// Suppose that we have a products repository defined like this:
class ProductsRepository {
  static Future<List<Product>> getAllProducts() async {
    // call api
    List<Product> products = await Api().getProducts();
    return products;
  }
}

class ProductsViewModel extends FlViewModel<List<Product>> {
  void loadProducts() {
    setFutureData(
      ProductsRepository.getAllProducts(),
      withLoading: false,
    ); // This will set the state to loading,  asynchronously load the list of products, update the state, and trigger the View to build the Data state
  }
}
```

The `setFutureData()` method sets the state to *Loading* just before executing the `Future`. If you
don't want to change the state to *Loading* while fetching the data, you can set the `withLoading`
parameter to `false`:

```dart
void loadProducts() {
  setFutureData(
    ProductsRepository.getAllProducts(),
    withLoading: false,
  ); // This will asynchronously load the list of products, update the state, and trigger the View to build the Data state
}
```

If the `Future` throws an *Error*, `setFutureData()` will catch it and change the state to
the *Error* state.

#### *Empty State* 💨

The state is considered empty when there is no value (`state.value == null`) or when the value is an
empty `Iterable` or `Map`.

If the specified condition is met, it triggers the **View** to render the Empty UI state.

You can use the built-in `setEmpty()` method to clear the current state:

```dart
class MyViewModel extends FlViewModel<List<int>> {
  void clear() {
    setEmpty(); // This will cause the view to render the Empty UI state
  }
}
```

By calling `setEmpty()`, you clear the current state of the **ViewModel**, which triggers the **
View** to
render the Empty UI state. This is useful when you want to indicate that there is no data to
display.

#### *Error State* ❗

To display the *Error* state you can use the built-in `setError()` method:

```dart
class CounterViewModel extends FlViewModel<int> {
  @override
  FutureOr<int?> build() {
    return 0;
  }

  void incrementCounter() {
    int currentValue = value ?? 0;
    int newValue = currentValue + 1;
    if (newValue > 10) {
      setError(Exception("You have reached the limits 👮"));

      // Alternatively you can use:
      // state = AsyncValue.error(Exception("You have reached the limits 👮"), StackTrace.current);
      // or
      // state = AsyncError(Exception("You have reached the limits 👮"), StackTrace.current);
    }
    state = AsyncValue.data(newValue);
  }
}
```

By calling `setError(Exception("You have reached the limits 👮"))`, you set the state to the *Error*
state, which triggers the **View** to render the corresponding UI for handling errors.
Alternatively,
you can directly assign `AsyncValue.error(Exception("You have reached the limits 👮"),
StackTrace.current)` or `AsyncError(Exception("You have reached the limits 👮"), StackTrace.current)`
to the state.

You can also set the *Error* state in a `catch` block:

```dart
class CounterViewModel extends FlViewModel<int> {
  @override
  FutureOr<int?> build() {
    return 0;
  }

  void incrementCounter() {
    try {
      int currentValue = value ?? 0;
      int newValue = currentValue + 1;
      if (newValue > 10) {
        throw Exception("You have reached the limits 👮");
      }
      state = AsyncValue.data(newValue);
    } catch (error, stack) {
      setError(error, stack);
    }
  }
}
```

In the `catch` block, you catch the error and set it using `setError(error, stack)`, which triggers
the
**View** to render the Error UI state.

### The View 👀

#### *Create a View* 🖌️

To create a **View**, simply create a new class that extends the `FlView` class

```dart
class MyView extends FlView {}
```

The view is a widget and can be part of your flutter Layout just like any other widget

```dart
class MyView extends FlView {
  const MyView({super.key}); // it is recommended to create a const constructor for your view
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("Hello world 🌍, what a wonderful view 👀!"),
          SizedBox(height: 24),
          MyView() // render your view
        ],
      ),
    );
  }
}
```

#### *Link a View to a ViewModel* 🔗

When you create a **View**, you will be asked to override the `createViewModel()` method, and return
an
object of type `FlViewModel`

```dart
class MyViewModel extends FlViewModel {}

class MyView extends FlView {

  @override
  FlViewModel createViewModel() {
    return MyViewModel();
  }

}
```

If you want your **View** to be linked to a specific type of **ViewModel** you can use the generic
type just like this:

```dart
class MyViewModel extends FlViewModel {}

class MyView extends FlView<MyViewModel> {

  @override
  MyViewModel createViewModel() {
    return MyViewModel();
  }

}
```

📝 The returned **ViewModel** instance will be linked to this **View** throughout the lifecycle of
the **View** and cannot be changed.

#### *Initialize the ViewModel with parameters* 🎛️

The `createViewModel()` method can come in handy when you want to initialize the view model with a
parameter passed through the view.

Imagine you have a view that show the list of users and that the you want to pass a filter to the
view to only show users from a given city.

```dart
class UsersViewModel extends FlViewModel<List<User>> {
  final String cityFilter;

  UsersViewModel(this.cityFilter);

  @override
  FutureOr<List<User>> build() {
    return UsersRepository.getUsers(
        city: cityFilter); // when the viewModel builds it's state it will use the value of the cityFilter
  }
}

class UsersView extends FlView<UsersViewModel> {
  final String cityFilter;

  const UsersView({super.key, requried this.cityFilter});

  @override
  UsersViewModel createViewModel() {
    return UsersViewModel(
        cityFilter); // create an instance of UsersViewModel and pass the value of the cityFilter 
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("Hello world 🌍, what a wonderful view 👀!"),
          SizedBox(height: 24),
          UsersView(cityFilter: "Paris")
          // Pass a parameter to the view the same way you do with any custom widget
        ],
      ),
    );
  }
}
```

#### *The UI states of a view* 🎨

The **View** can handle 4 states of UI

1. Data
2. Empty
3. Loading
4. Error

By default the view is initialized with the *Data* UI state
Each UI state is handled by a method that returns a `Widget` that you can customize by overriding
it.

The `FlView` class provides a default `Widget` for all the states except for the *Data* state, which
you are obliged to implement when you extend the `FlView` class

```dart
class Model {
  final String data;

  const Model(this.data);
}

class MyViewModel extends FlViewModel<Model> {
  @override
  FutureOr<Model> build() {
    return const Model("abc");
  }
}

class MyView extends FlView<MyViewModel> {
  const MyView({super.key});

  @override
  Widget buildDataState(BuildContext context, MyViewModel viewModel) {
    return Text("Hello 👋 I'm a friendly view, checkout my data => ${viewModel.value?.data}");
    // output: Hello 👋 I'm a friendly view, checkout my data => abc
  }

  @override
  MyViewModel createViewModel() {
    return MyViewModel();
  }
}
```

Feel free to override the remaining UI states to fit your needs

```dart
class MyView extends FlView<MyViewModel> {
  const MyView({super.key});

  @override
  Widget buildDataState(BuildContext context, MyViewModel viewModel) {
    return Text("Hello 👋 I'm a friendly view, checkout my data => ${viewModel.value?.data}");
    // output: Hello 👋 I'm a friendly view, checkout my data => abc
  }

  @override
  Widget buildErrorState(BuildContext context, MyViewModel viewModel, String error) {
    return Text("🛑 $error");
  }

  @override
  Widget buildEmptyState(BuildContext context, MyViewModel viewModel) {
    return Text("🍃 There's no data");
  }

  @override
  Widget buildLoadingState(BuildContext context, MyViewModel viewModel) {
    return Text("⏰ Please wait while the view is loading data...");
  }


  @override
  MyViewModel createViewModel() {
    return MyViewModel();
  }
}
```

#### *Wrapping the View with a Container* 📦

Sometimes, you might need to wrap your **View** inside a container, you can do it the traditional
way by wrapping the whole **View** widget with another widget that acts as a
container

```dart 
Container(child: MyView())
```

Or you can override the `buildContainer()` method to use an inner container that will wrap
the rendered UI states, while giving you access to the `FlViewModel` instance

```dart
class Model {
  final String data;

  const Model(this.data);
}

class MyViewModel extends FlViewModel<Model> {
  @override
  FutureOr<Model> build() {
    return const Model("abc");
  }
}

class MyView extends FlView<MyViewModel> {
  const MyView({super.key});

  @override
  Widget? buildContainer(BuildContext context,
      Widget child,
      MyViewModel viewModel,) {
    // Using a Scaffold as an inner view wrapper
    return Scaffold(
      // Notice that the view model is accessible from the container making it possible for you to use the state in the container
      appBar: AppBar(
        title: Text("The data inside the model is ${viewModel.value?.data}"),
      ),
      body: child,
    );
  }

  @override
  Widget buildDataState(BuildContext context, MyViewModel viewModel) {
    return Text("Hello 👋 I'm a friendly view, checkout my data => ${viewModel.value?.data}");
    // output: Hello 👋 I'm a friendly view, checkout my data => abc
  }

  @override
  MyViewModel createViewModel() {
    return MyViewModel();
  }
}
```

---
📝 PS: You can find a full example in the `/example` folder.

## Additional information ℹ️

Thank you for using this package! Your feedback and contribution are greatly appreciated.
As a single developer, I have created this package with the intention of assisting you in building
reactive views using the MVVM pattern and Riverpod.
While I have put in my best effort, please note that this package may not be perfect or suitable for
all types of projects. If you encounter any issue or have suggestions for improvement, please don't
hesitate to file an issue on the Github repository. Additionally, contributions in the form of pull
requests are always welcome!
Your involvement can help enhance the package and make it even more valuable for the community.
Thank you for your support and understanding as we work together to create better and more reactive
applications.
