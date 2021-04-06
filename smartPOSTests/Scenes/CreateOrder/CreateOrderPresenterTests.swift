//
//  CreateOrderPresenterTests.swift
//  smartPOS
//
//  Created by Raymond Law on 09/07/15.
//  Copyright (c) 2015 Raymond Law. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import smartPOS
import UIKit
import XCTest

class CreateOrderPresenterTests: XCTestCase
{
  // MARK: - Subject under test
  
  var sut: CreateOrderPresenter!
  
  // MARK: - Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupCreateOrderPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupCreateOrderPresenter()
  {
    sut = CreateOrderPresenter()
  }
  
  // MARK: - Test doubles
  
  class CreateOrderDisplayLogicSpy: CreateOrderDisplayLogic
  {
    // MARK: Method call expectations
    
    var displayExpirationDateCalled = false
    var displayCreatedOrderCalled = false
    var displayOrderToEditCalled = false
    var displayUpdatedOrderCalled = false
    
    // MARK: Argument expectations
    
    var formatExpirationDateViewModel: CreateOrder.FormatExpirationDate.ViewModel!
    var createOrderViewModel: CreateOrder.CreateOrder.ViewModel!
    var editOrderViewModel: CreateOrder.EditOrder.ViewModel!
    var updateOrderViewModel: CreateOrder.UpdateOrder.ViewModel!
    
    // MARK: Spied methods
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    {
      displayExpirationDateCalled = true
      self.formatExpirationDateViewModel = viewModel
    }
    
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    {
      displayCreatedOrderCalled = true
      self.createOrderViewModel = viewModel
    }
    
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    {
      displayOrderToEditCalled = true
      self.editOrderViewModel = viewModel
    }
    
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
    {
      displayUpdatedOrderCalled = true
      self.updateOrderViewModel = viewModel
    }
  }
  
  class CreateOrderDisplayLogicMock: CreateOrderDisplayLogic
  {
    // MARK: Method call expectations
    
    var displayExpirationDateCalled = false
    var displayCreatedOrderCalled = false
    var displayOrderToEditCalled = false
    var displayUpdatedOrderCalled = false
    
    // MARK: Argument expectations
    
    var formatExpirationDateViewModel: CreateOrder.FormatExpirationDate.ViewModel!
    var createOrderViewModel: CreateOrder.CreateOrder.ViewModel!
    var editOrderViewModel: CreateOrder.EditOrder.ViewModel!
    var updateOrderViewModel: CreateOrder.UpdateOrder.ViewModel!
    
    // MARK: Spied methods
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    {
      displayExpirationDateCalled = true
      self.formatExpirationDateViewModel = viewModel
    }
    
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    {
      displayCreatedOrderCalled = true
      self.createOrderViewModel = viewModel
    }
    
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    {
      displayOrderToEditCalled = true
      self.editOrderViewModel = viewModel
    }
    
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
    {
      displayUpdatedOrderCalled = true
      self.updateOrderViewModel = viewModel
    }
    
    // MARK: Verifications
    
    func verifyDisplayExpirationDateIsCalled() -> Bool
    {
      return displayExpirationDateCalled
    }
    
    func verifyExpirationDateIsFormattedAs(date: String) -> Bool
    {
      return formatExpirationDateViewModel.date == date
    }
    
    func verifyEditOrderViewModelOrderFormFields(order: Order) -> Bool
    {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .short
      dateFormatter.timeStyle = .none
      let orderPaymentMethodExpirationDate = dateFormatter.string(from: order.paymentMethod.expirationDate)
      
      return editOrderViewModel.orderFormFields.firstName == order.firstName &&
        editOrderViewModel.orderFormFields.lastName == order.lastName &&
        editOrderViewModel.orderFormFields.phone == order.phone &&
        editOrderViewModel.orderFormFields.email == order.email &&
        
        editOrderViewModel.orderFormFields.billingAddressStreet1 == order.billingAddress.street1 &&
        editOrderViewModel.orderFormFields.billingAddressStreet2 == order.billingAddress.street2 &&
        editOrderViewModel.orderFormFields.billingAddressCity == order.billingAddress.city &&
        editOrderViewModel.orderFormFields.billingAddressState == order.billingAddress.state &&
        editOrderViewModel.orderFormFields.billingAddressZIP == order.billingAddress.zip &&
        
        editOrderViewModel.orderFormFields.paymentMethodCreditCardNumber == order.paymentMethod.creditCardNumber &&
        editOrderViewModel.orderFormFields.paymentMethodCVV == order.paymentMethod.cvv &&
        editOrderViewModel.orderFormFields.paymentMethodExpirationDate == order.paymentMethod.expirationDate &&
        editOrderViewModel.orderFormFields.paymentMethodExpirationDateString == orderPaymentMethodExpirationDate &&
        
        editOrderViewModel.orderFormFields.shipmentAddressStreet1 == order.shipmentAddress.street1 &&
        editOrderViewModel.orderFormFields.shipmentAddressStreet2 == order.shipmentAddress.street2 &&
        editOrderViewModel.orderFormFields.shipmentAddressCity == order.shipmentAddress.city &&
        editOrderViewModel.orderFormFields.shipmentAddressState == order.shipmentAddress.state &&
        editOrderViewModel.orderFormFields.shipmentAddressZIP == order.shipmentAddress.zip &&
        
        editOrderViewModel.orderFormFields.shipmentMethodSpeed == order.shipmentMethod.speed.rawValue &&
        editOrderViewModel.orderFormFields.shipmentMethodSpeedString == order.shipmentMethod.toString() &&
        
        editOrderViewModel.orderFormFields.id == order.id &&
        editOrderViewModel.orderFormFields.date == order.date &&
        editOrderViewModel.orderFormFields.total == order.total
    }
  }
  
  // MARK: - Test expiration date
  
  func testPresentExpirationDateShouldConvertDateToStringUsingSpy()
  {
    // Given
    let createOrderDisplayLogicSpy = CreateOrderDisplayLogicSpy()
    sut.viewController = createOrderDisplayLogicSpy
    
    // When
    var dateComponents = DateComponents()
    dateComponents.year = 2007
    dateComponents.month = 6
    dateComponents.day = 29
    let date = Calendar.current.date(from: dateComponents)!
    let response = CreateOrder.FormatExpirationDate.Response(date: date)
    sut.presentExpirationDate(response: response)
    
    // Then
    let expectedDate = "6/29/07"
    let returnedDate = createOrderDisplayLogicSpy.formatExpirationDateViewModel.date
    XCTAssertEqual(returnedDate, expectedDate, "Presenting an expiration date should convert date to string")
  }
  
  func testPresentExpirationDateShouldConvertDateToStringUsingMock()
  {
    // Given
    let createOrderDisplayLogicMock = CreateOrderDisplayLogicMock()
    sut.viewController = createOrderDisplayLogicMock
    
    // When
    var dateComponents = DateComponents()
    dateComponents.year = 2007
    dateComponents.month = 6
    dateComponents.day = 29
    let date = Calendar.current.date(from: dateComponents)!
    let response = CreateOrder.FormatExpirationDate.Response(date: date)
    sut.presentExpirationDate(response: response)
    
    // Then
    let expectedDate = "6/29/07"
    XCTAssert(createOrderDisplayLogicMock.verifyExpirationDateIsFormattedAs(date: expectedDate), "Presenting an expiration date should convert date to string")
  }
  
  func testPresentExpirationDateShouldAskViewControllerToDisplayDateStringUsingSpy()
  {
    // Given
    let createOrderDisplayLogicSpy = CreateOrderDisplayLogicSpy()
    sut.viewController = createOrderDisplayLogicSpy
    
    // When
    let response = CreateOrder.FormatExpirationDate.Response(date: Date())
    sut.presentExpirationDate(response: response)
    
    // Then
    XCTAssert(createOrderDisplayLogicSpy.displayExpirationDateCalled, "Presenting an expiration date should ask view controller to display date string")
  }
  
  func testPresentExpirationDateShouldAskViewControllerToDisplayDateStringUsingMock()
  {
    // Given
    let createOrderDisplayLogicMock = CreateOrderDisplayLogicMock()
    sut.viewController = createOrderDisplayLogicMock
    
    // When
    let response = CreateOrder.FormatExpirationDate.Response(date: Date())
    sut.presentExpirationDate(response: response)
    
    // Then
    XCTAssert(createOrderDisplayLogicMock.verifyDisplayExpirationDateIsCalled(), "Presenting an expiration date should ask view controller to display date string")
  }
  
  // MARK: - Test created order
  
  func testPresentCreatedOrderShouldAskViewControllerToDisplayTheNewlyCreatedOrder()
  {
    // Given
    let createOrderDisplayLogicSpy = CreateOrderDisplayLogicSpy()
    sut.viewController = createOrderDisplayLogicSpy
    
    // When
    let order = Seeds.Orders.amy
    let response = CreateOrder.CreateOrder.Response(order: order)
    sut.presentCreatedOrder(response: response)
    
    // Then
    XCTAssert(createOrderDisplayLogicSpy.displayCreatedOrderCalled, "Presenting the newly created order should ask view controller to display it")
    XCTAssertNotNil(createOrderDisplayLogicSpy.createOrderViewModel.order, "Presenting the newly created order should succeed")
  }
  
  // MARK: Test editing order
  
  func testPresentOrderToEditShouldFormatTheExistingOrderForDisplayUsingSpy()
  {
    // Given
    let createOrderDisplayLogicSpy = CreateOrderDisplayLogicSpy()
    sut.viewController = createOrderDisplayLogicSpy
    
    // When
    let order = Seeds.Orders.amy
    let response = CreateOrder.EditOrder.Response(order: order)
    sut.presentOrderToEdit(response: response)
    
    // Then
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .none
    let orderPaymentMethodExpirationDate = dateFormatter.string(from: order.paymentMethod.expirationDate)
    
    XCTAssert(createOrderDisplayLogicSpy.displayOrderToEditCalled, "Presenting the order to edit should ask view controller to display it")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.firstName, order.firstName, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.lastName, order.lastName, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.phone, order.phone, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.email, order.email, "Presenting the order to edit should format the existing order")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.billingAddressStreet1, order.billingAddress.street1, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.billingAddressStreet2, order.billingAddress.street2, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.billingAddressCity, order.billingAddress.city, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.billingAddressState, order.billingAddress.state, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.billingAddressZIP, order.billingAddress.zip, "Presenting the order to edit should format the existing order")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.paymentMethodCreditCardNumber, order.paymentMethod.creditCardNumber, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.paymentMethodCVV, order.paymentMethod.cvv, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.paymentMethodExpirationDate, order.paymentMethod.expirationDate, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.paymentMethodExpirationDateString, orderPaymentMethodExpirationDate, "Presenting the order to edit should format the existing order")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentAddressStreet1, order.shipmentAddress.street1, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentAddressStreet2, order.shipmentAddress.street2, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentAddressCity, order.shipmentAddress.city, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentAddressState, order.shipmentAddress.state, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentAddressZIP, order.shipmentAddress.zip, "Presenting the order to edit should format the existing order")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentMethodSpeed, order.shipmentMethod.speed.rawValue, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.shipmentMethodSpeedString, order.shipmentMethod.toString(), "Presenting the order to edit should format the existing order")
    
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.id, order.id, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.date, order.date, "Presenting the order to edit should format the existing order")
    XCTAssertEqual(createOrderDisplayLogicSpy.editOrderViewModel.orderFormFields.total, order.total, "Presenting the order to edit should format the existing order")
  }
  
  func testPresentOrderToEditShouldFormatTheExistingOrderForDisplayUsingMock()
  {
    // Given
    let createOrderDisplayLogicMock = CreateOrderDisplayLogicMock()
    sut.viewController = createOrderDisplayLogicMock
    
    // When
    let order = Seeds.Orders.amy
    let response = CreateOrder.EditOrder.Response(order: order)
    sut.presentOrderToEdit(response: response)
    
    // Then
    XCTAssert(createOrderDisplayLogicMock.displayOrderToEditCalled, "Presenting the order to edit should ask view controller to display it")
    XCTAssertTrue(createOrderDisplayLogicMock.verifyEditOrderViewModelOrderFormFields(order: order), "Presenting the order to edit should format the existing order")
  }
  
  // MARK: - Test updating an order
  
  func testPresentUpdatedOrderShouldAskViewControllerToDisplayTheUpdatedOrder()
  {
    // Given
    let createOrderDisplayLogicSpy = CreateOrderDisplayLogicSpy()
    sut.viewController = createOrderDisplayLogicSpy
    
    // When
    let order = Seeds.Orders.amy
    let response = CreateOrder.UpdateOrder.Response(order: order)
    sut.presentUpdatedOrder(response: response)
    
    // Then
    XCTAssert(createOrderDisplayLogicSpy.displayUpdatedOrderCalled, "Presenting the updated order should ask view controller to display it")
    XCTAssertNotNil(createOrderDisplayLogicSpy.updateOrderViewModel.order, "Presenting the updated order should succeed")
  }
}
