A concise and powerful Flutter package that implements the **MVVM** (*Model-View-ViewModel*)
architecture.
Built on top of **[Signals](https://pub.dev/packages/signals)** for state management, this package provides a seamless and efficient
way to
handle the state of the view in your Flutter applications. With a clean separation of concerns and a
reactive approach, it simplifies the development process and enhances the maintainability of your
codebase. Empower your Flutter projects with the **MVVM** architecture and leverage the capabilities
of
**[Signals](https://pub.dev/packages/signals)** for efficient state management.

## Features 🎯

1. 🏗️ **View and View Model Creation:** Easily create Views and View Models for your application.

1. 🛠️ **State Handling:** Built-in support for various predefined states such as Data State, Loading State, Error State and Empty State.

1. 🎨 **Custom State Support:** Define and integrate custom states tailored to the application's needs.

1. 🔄 **State-Driven UI:** Views react dynamically to state changes, with each state managed separately in dedicated build methods.

1. 📦 **Custom Container Support:** Include custom containers that remain unaffected by state changes, providing consistent UI elements across different states.

1. 🧩 **Flexible UI Behavior:** Override methods to customize UI behavior for each state, ensuring a seamless user experience.

1. 💉 **Dependency Management:** View Models can depend on other View Model states through reactive signals, enabling reactive state management throughout the application.

1. ⚗️ **Reactive State Management:** Utilize reactive programming paradigms to manage state efficiently across the entire application.

## Usage 🔨

* [The ViewModel](#the-viewmodel)
    * [Create a ViewModel 🏗️](#create-a-viewmodel-)
    * [Using the state 💾](#using-the-state-)
    * [onViewInitialized 🌱](#onviewinitialized-)
    * [onDispose ♻️](#ondispose-)
    * [Auto Dispose 🤖](#auto-dispose-)
    * [Loading State ⏳](#loading-state-)
    * [Data State 📊](#data-state-)
    * [Future Data ⏭](#future-data-)
    * [Empty State 🫙](#empty-state-)
    * [Error State ❗](#error-state-)
    * [Custom State 📦](#custom-state-)
    * [Depending on other view models ⚗️](#depending-on-other-view-models-)
* [The View 👀](#the-view-👀)
    * [Create a View 🖌️](#create-a-view-)
    * [Link a View to a ViewModel 🔗](#link-a-view-to-a-viewmodel-)
    * [Keep the view model alive🍃](#keep-the-view-model-alive-)
    * [The UI states of a View 🎨](#the-ui-states-of-a-view-)
    * [Wrapping the View with a Container 📦](#wrapping-the-view-with-a-container-)
* [Testing 🧪](#testing-)

### The ViewModel

#### *Create a ViewModel* 🏗️

To create a **ViewModel**, simply create a class that extends the `FlViewModel` class

```dart
class MyViewModel extends FlViewModel {}
```

#### *Using the state* 💾

The state of each **ViewModel** is accessible using the getter `value`

```dart

MyViewModel viewModel = MyViewModel();
dynamic state = viewModel.value;
```

As you can see the type of the state is `dynamic` but you can set the type to whatever you want using a generic type

```dart

MyViewModel viewModel = MyViewModel<String>();
String? state = viewModel.value;
```

By default, the state of the view model will be an Empty State, and the value of an empty state will be `null`.

#### *onViewInitialized* 🌱

`onViewInitialized()` is a useful method that allows you to run code typically for initializing parameters, immediately after the **View** is initialized

```dart
class MyViewModel extends FlViewModel {
  @override
  void onViewInitialized() {
    // This code will run only once when the associated View is initialized.
  }
}
```

📝 This method is executed only once when the first view using this view model is initialized.

#### *onDispose* ♻️

`onDispose()` is a useful method that you can use to clean things up. For example, you can release some resources like listeners, streams or files.

> 💡 This method will be called when the view model is getting disposed of

```dart
class MyViewModel extends FlViewModel {
  @override
  void onDispose() {
    // This code will run when the view model is getting disposed of
    // You might want to release resources, dispose of a disposable state, stop a timer, etc...
  }
}
```

#### *Auto Dispose* 🤖

Setting `autoDispose` to true will automatically mark the view model as disposed of when there are no more state listeners (Either Views or ViewModels).

```dart
class MyViewModel extends FlViewModel{
  MyViewModel({super.autoDispose});
}

MyViewModel vm = MyViewModel(autoDispose:true);
```

By default, `autoDispose` is set to false.
> ⚠️ Do not set `autoDispose` to true if other views or view models might depend on the state of your view model in the future
#### *Loading State* ⏳

To display the *Loading state* you can use the built-in `setLoading()` method:

```dart
class MyViewModel extends FlViewModel {

  void loadUsers() async {
    setLoading(); // This will cause the View to render the loading UI state
    /*...Continue loading users...*/
  }
}
```

By calling `setLoading()`, you trigger the **View** to render the loading UI state, indicating that data is being fetched or processed.

#### *Data State* 📊

To display the *Data state* you can use the built-in `setData()` method:

```dart
class CounterViewModel extends FlViewModel<int> {

  void incrementCounter() {
    int currentValue = value ?? 0;
    int newValue = currentValue + 1;
    setData(newValue); // This will cause the view to render the new Data

  }
}
```

By calling `setData(newValue)`, you update the **ViewModel** state with the new value, which
triggers the **View** to render the updated Data state.

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

#### *Empty State* 🫙
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
render the Empty UI state. This is useful when you want to indicate that there is no data to display.

#### *Error State* ❗

To display the *Error* state you can use the built-in `setError()` method:

```dart
class CounterViewModel extends FlViewModel<int> {

  void incrementCounter() {
    int currentValue = value ?? 0;
    int newValue = currentValue + 1;
    if (newValue > 10) {
      setError(Exception("You have reached the limits 👮"));
    } else{
      setData(newValue);
    }
  }
}
```

By calling `setError(Exception("You have reached the limits 👮"))`, you set the state to the *Error*
state, which triggers the **View** to render the corresponding UI for handling errors.

You can also set the *Error* state in a `catch` block:

```dart
class CounterViewModel extends FlViewModel<int> {

  void incrementCounter() {
    try {
      int currentValue = value ?? 0;
      int newValue = currentValue + 1;
      if (newValue > 10) {
        throw Exception("You have reached the limits 👮");
      }
      setData(newValue);
    } catch (error, stack) {
      setError(error, stack);
    }
  }
}
```

In the `catch` block, you catch the error and set it using `setError(error, stack)`, which triggers
the **View** to render the Error UI state.

#### *Custom State* 📦

If you want to create a custom state simply implement the FlState interface

```dart
class CustomState implements FlState{
 // implementation ...
}
 ```

 then use `viewModel.setState()` to use your custom state.

For example, you might want to customize how the data is displayed:
```dart
enum DisplayMode{
  list,
  grid
}

class MyCustomState<T> implements FlState<T> {
  const MyCustomState({required this.mode, this.data});
  final DisplayMode mode;
  @override
  final T? data;
}
  
myViewModel.setState(MyCustomLoadingState(mode: DisplayMode.list, data: [/*Lorem, Ipsum*/]));
```

#### *Depending on other view models* ⚗️
Sometimes your view model requires the state of another view model and needs to rebuild on state change.

Let's say you have a `ProductsViewModel` and a `FavoritesViewModel`. The `FavoritesViewModel` must filter favorites out of the products in the `ProductsViewModel`. To do so, simply override the `buildDependencies()` method.

```dart
final getIt = GetIt.instance;

void main(){
  getIt.registerSingleton<ProductsViewModel>(ProductsViewModel());
}

/// Holds the list of available products
class ProductsViewModel extends FlViewModel<List<Product>>{

}

class FavoriteProductsViewModel extends FlViewModel<List<Product>>{
  @override
  buildDependencies(){
    // Accessing ProductsViewModel.value will make this instance to automatically subscribe to the state of the ProductsViewModel instance

    // In other words, when the state of ProductsViewModel updates
    // This method will get called again
    var favorites = getIt.get<ProductsViewModel>().value?.where((e)=>e.isFavorie);
    setData(favorites);
  }
}

```
If you access another view model's value inside the `buildDependencies` method, the current view model will subscribe to the state of the other view model and whenever the state of the other view model (in our example the `ProductsViewModel`) the `buildDependencies` will get called again.

In the case of the products/favorites, this can help manage the state across the app, since whenever the product list changes the favorites get updated right away.

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

When you create a **View**, you will be asked to override the `createViewModel()` method and return an object of type `FlViewModel`

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

> 📝 The returned **ViewModel** instance will be linked to this **View** throughout the lifecycle of the **View** and cannot be changed.

Alternatively, you can pass a view model through the constructor:

```dart

class MyView extends FlView<MyViewModel>{
  const MyView({super.viewModel,});
}


MyView(viewModel: someViewModel);
```

#### *Keep the view model alive* 🍃
In some cases, a View Model can act as a state manager and other views and view models depend on its state.

Suppose we want to have a view model that holds a list of products, and a view to display the loaded products.
But this time we will have another view that displays our favorite products.

To do so, we must keep one view model that holds all the available products and inject it into memory using a service locator like [get_it](https://pub.dev/packages/get_it).

The `ProductsListView` will depend on the state of the `ProductsViewModel` and so is the `FavoriteProductsViewModel`.

By default, when a view is being disposed of it will attempt to dispose the view model as well. But In our case, we don't want the `ProductsViewModel` to get disposed of due to other parts of our application relying on its state.
That's when `keepViewModelAlive` comes in handy, when set to true, the view won't attempt to dispose of the view model with it.
This way even if the `ProductsListView` gets disposed of, the `ProductsViewModel` will stay alive, and its state will be usable. 

You can set KeepViewModelAlive simply by using the super constructor like this:
```dart
class MyView extends FlView{
  const MyView({super.key}):super(keepViewModelAlive:true);
}
```

Example:

```dart
final getIt = GetIt.instance;

void main(){
  getIt.registerSingleton<ProductsViewModel>(ProductsViewModel());
}

/// Holds the list of available products
class ProductsViewModel extends FlViewModel<List<Product>>{

}

class ProductsListView extends FlView<ProductsViewModel>{

  const ProductsListView():super(keepViewModelAlive:true);
  @override
  ProductsViewModel createViewModel(){
    return getIt.get<ProductsViewModel>();
  }
}

class FavoriteProductsViewModel extends FlViewModel<List<Product>>{
  @override
  buildDependencies(){
    var favorites = getIt.get<ProductsViewModel>().value?.where((e)=>e.isFavorie);
    setData(favorites);
  }
}

class FavoriteProductsView extends FlView<FavoriteProductsViewModel>{
  @override
  FavoriteProductsViewModel createViewModel(){
    return FavoriteProductsViewModel();
  }
}
```
#### *The UI states of a view* 🎨

The **View** can handle 4 states of UI

1. Data
2. Empty
3. Loading
4. Error

Each UI state is handled by a method that returns a `Widget` that you can customize by overriding
it.

The `FlView` class provides a default `Widget` for all the states except for the *Data* state, which
you are obliged to implement when you extend the `FlView` class

```dart
class Model {
  final String data;

  const Model({this.data="abc"});
}

class MyViewModel extends FlViewModel<Model> {
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
If you want to handle the UI of custom states, just override the `buildCustomState` method:

```dart
  @override
  Widget buildCustomState(
      BuildContext context, FlState state, MyViewModel viewModel) {
    return const Text('Custom State');
  }
```
#### *Wrapping the View with a Container* 📦

Sometimes, you might need to wrap your **View** inside a container, you can do it the traditional way by wrapping the whole **View** widget with another widget that acts as a container

```dart 
Container(child: MyView())
```

Or you can override the `buildContainer()` method to use an inner container that will wrap the rendered UI states while giving you access to the `FlViewModel` instance

```dart
class Model {
  final String data;

  const Model({this.data="abc"});
}

class MyViewModel extends FlViewModel<Model> {

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

### Testing 🧪

You can test the view like any other widget, and if you want to inject a mock view model you can do so by using the viewModel parameter in the constructor of the view.

```dart
class MyView extends FlView{
  const MyView({super.key, super.viewModel});
}
/**
.
.
.
*/
 await tester.pumpWidget(MaterialApp(
      home: MyView(
        viewModel: mockViewModel,
      ),
    ));
```

On the other hand, view models have a useful method that you can use in your unit tests, which is `waitForStateChange`.

This method will allow you to asynchronously wait for the state to change

```dart
 test('Test data reloaded', () async {
    // Arrange
    ExampleViewModel viewModel = ExampleViewModel(numberOfItems: 3);
    // Act
    viewModel.reload();
    await viewModel.waitForStateChange<FlDataState>(timeout: 1000);
    // Assert
    expect(viewModel.value?.length, equals(3));
  });
```
---
📝 PS: You can find a full example in the `/example` folder.

## Additional information ℹ️

Thank you for using this package! Your feedback and contribution are greatly appreciated.
As a single developer, I have created this package with the intention of assisting you in building
reactive views using the MVVM pattern and **[Signals](https://pub.dev/packages/signals)**.
While I have put in my best effort, please note that this package may not be perfect or suitable for
all types of projects. If you encounter any issues or have suggestions for improvement, please don't
hesitate to file an issue on the Github repository. Additionally, contributions in the form of pull
requests are always welcome!
Your involvement can help enhance the package and make it even more valuable for the community.
Thank you for your support and understanding as we work together to create better and more reactive
applications.
