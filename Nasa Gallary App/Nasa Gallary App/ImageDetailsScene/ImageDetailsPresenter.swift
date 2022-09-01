//
//  ImageDetailsPresenter.swift
//  Nasa Gallary App
//
//  Created by ADMIN on 01/09/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ImageDetailsPresentationLogic
{
  func presentSomething(response: ImageDetails.Something.Response)
}

class ImageDetailsPresenter: ImageDetailsPresentationLogic
{
  weak var viewController: ImageDetailsDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: ImageDetails.Something.Response)
  {
    let viewModel = ImageDetails.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
